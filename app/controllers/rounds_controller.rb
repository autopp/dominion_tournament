class RoundsController < ApplicationController
  before_action only: %i[show edit list update] do
    @round = Round.find_by(tournament_id: params[:tournament_id], number: params[:id])
    @tables = @round.tables
  end

  def create
    unless authorized?('admin')
      flash[:danger] = 'Not permitted operation'
      redirect_to tournament_path(id: params[:tournament_id])
      return
    end

    @tournament = Tournament.find(params[:tournament_id])
    ActiveRecord::Base.transaction do
      @round = create_round(@tournament)
    end

    redirect_to edit_tournament_round_path(tournament_id: @tournament.id, id: @round.number)
  end

  def show
    return unless @round.tournament.ongoing_round == @round

    redirect_to edit_tournament_round_path(tournament_id: params[:tournament_id],
                                           number: params[:id])
  end

  def list
  end

  def edit
    return if @round.tournament.ongoing_round == @round

    redirect_to tournament_round_path(tournament_id: params[:tournament_id], number: params[:id])
  end

  def update
    check_auth('admin', fall_back: :edit) || return

    if @round.finished?
      render_with_errors :edit, errors: ['Already finished']
      return
    end

    try_finish_round
  end

  private

  def create_round(tournament)
    round = tournament.rounds.create!(number: tournament.rounds.count + 1)
    tournament.matchings.each.with_index(1) do |players, i|
      players.each do |player|
        Score.create!(tournament: tournament, player: player, round_number: round.number, table_number: i)
      end
    end
    tournament.has_ongoing_round = true
    tournament.save!

    round
  end

  def try_finish_round
    not_completed_tables = @round.not_completed_tables
    unless not_completed_tables.empty?
      errors = not_completed_tables.map { |table| "Table #{table.number} is not completed" }
      render_with_errors :edit, errors: errors
      return
    end
    @round.finish!
    flash[:success] = "Round #{@round.number} is finished!"
    redirect_to tournament_path(id: params[:tournament_id])
  end
end

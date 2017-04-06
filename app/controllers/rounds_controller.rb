class RoundsController < ApplicationController
  before_action only: [:show, :edit, :list, :update] do
    @round = Round.find_by(tournament_id: params[:tournament_id], number: params[:id])
    @tables = @round.tables.includes(:scores)
  end

  def create
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
    if @round.finished?
      render_with_errors :edit, errors: ['Already finished']
      return
    end

    results = update_scores
    err_msgs = results.reject(&:first).map { |_status, msg| msg }

    if !err_msgs.empty?
      render_with_errors :edit, errors: err_msgs
    elsif params[:finish]
      try_finish_round
    else
      flash[:success] = 'Updated!'
      render :edit
    end
  end

  private

  def create_round(tournament)
    round = tournament.rounds.create!(number: tournament.rounds.count + 1)
    tournament.matchings.each.with_index(1) do |players, i|
      table = round.tables.create!(number: i)
      players.each do |player|
        table.scores.create!(player: player)
      end
    end

    round
  end

  def update_scores
    input = params[:scores]
    Table.where(round_id: @round.id).includes(:scores).each_with_object([]) do |table, results|
      scores = table.scores
      player_num = scores.count
      table_inputs = input[table.id.to_s]
      scores.each do |score|
        results << score.update_by_input(table_inputs[score.id.to_s], player_num)
      end
    end
  end

  def try_finish_round
    not_completed_tables = @round.not_completed_tables
    unless not_completed_tables.empty?
      @errors = not_completed_tables.map { |table| "Table #{table.number} is not completed" }
      render :edit
      return
    end
    @round.finish!
    flash[:success] = "Round #{@round.number} is finished!"
    redirect_to tournament_path(id: params[:tournament_id])
  end
end

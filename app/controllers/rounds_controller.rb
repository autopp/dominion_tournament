class RoundsController < ApplicationController
  before_action only: %i[show edit list update] do
    @tournament = Tournament.find(params[:tournament_id])
    @round = Round.new(tournament: @tournament, number: params[:id].to_i)
    @tables = @round.tables
  end

  before_action only: %i[update] do
    check_auth('admin', fall_back: :edit)
  end

  def create
    unless authorized?('admin')
      flash[:danger] = 'Not permitted operation'
      redirect_to tournament_path(id: params[:tournament_id])
      return
    end

    @tournament = Tournament.find(params[:tournament_id])
    @round = @tournament.start_round

    redirect_to edit_tournament_round_path(tournament_id: @tournament.id, id: @round.number)
  end

  def show
    return unless @round.tournament.ongoing_round&.number == @round.number

    redirect_to edit_tournament_round_path(tournament_id: params[:tournament_id],
                                           number: params[:id])
  end

  def list
  end

  def edit
    return if @round.tournament.ongoing_round&.number == @round.number

    redirect_to tournament_round_path(tournament_id: params[:tournament_id], number: params[:id])
  end

  def update
    if @round.finished?
      render_with_errors :edit, errors: ['Already finished']
      return
    end

    try_finish_round
  end

  private

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

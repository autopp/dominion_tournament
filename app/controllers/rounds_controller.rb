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
    if !authorized?('admin')
      flash[:danger] = 'Not permitted operation'
      redirect_to tournament_path(id: params[:tournament_id])
      return
    end

    @tournament = Tournament.find(params[:tournament_id])
    @round = @tournament.start_round!

    redirect_to edit_tournament_round_path(tournament_id: @tournament.id, id: @round.number)
  end

  def show
    return if @round.tournament.ongoing_round&.number != @round.number

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
    result, msgs = @round.finish!
    if result
      flash[:success] = msgs.first
      redirect_to tournament_path(id: params[:tournament_id])
    else
      render_with_errors :edit, errors: msgs
    end
  end
end

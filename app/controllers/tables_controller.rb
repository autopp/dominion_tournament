class TablesController < ApplicationController
  before_action only: [:show, :edit, :list, :update] do
    @round = Round.find_by(tournament_id: params[:tournament_id], number: params[:round_id])
    @table = Table.find_by(round_id: @round.id, number: params[:id])
  end

  def show
    return unless @round.tournament.ongoing_round == @round
    redirect_to edit_tournament_round_table_path(
      tournament_id: params[:tournament_id], round_id: params[:round_id], number: params[:id]
    )
  end

  def edit
    return if @round.tournament.ongoing_round == @round
    redirect_to tournament_round_table_path(
      tournament_id: params[:tournament_id], round_id: params[:round_id], number: params[:id]
    )
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
end
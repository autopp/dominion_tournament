class TablesController < ApplicationController
  before_action only: %i[show edit list update] do
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
    check_auth('staff', :edit) || return

    if @round.finished?
      render_with_errors :edit, errors: ['Already finished']
      return
    end

    results = update_scores
    err_msgs = results.reject(&:first).map { |_status, msg| msg }

    if !err_msgs.empty?
      render_with_errors :edit, errors: err_msgs
    else
      flash[:success] = "Table #{@table.number} was updated!"
      redirect_to edit_tournament_round_path(tournament_id: @round.tournament_id, id: @round.number)
    end
  end

  private

  def update_scores
    inputs = params[:scores]
    scores = @table.scores
    player_num = scores.count
    total_vp_used = @round.tournament.total_vp_used
    scores.map do |score|
      score.update_by_input(inputs[score.id.to_s], player_num, total_vp_used)
    end
  end
end

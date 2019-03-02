class TablesController < ApplicationController
  before_action only: %i[show edit list update] do
    round_number = params[:round_id].to_i
    @tournament = Tournament.find(params[:tournament_id])
    @round = Round.new(tournament: @tournament, number: round_number)
    @table = Table.new(tournament: @tournament, round_number: round_number, number: params[:id])
  end

  before_action only: %i[update] do
    check_auth('staff', fall_back: :edit)
  end

  def show
    return if @tournament.ongoing_round&.number != @round.number

    redirect_to edit_tournament_round_table_path(
      tournament_id: params[:tournament_id], round_id: params[:round_id], number: params[:id]
    )
  end

  def edit
    return if @tournament.ongoing_round&.number == @round.number

    redirect_to tournament_round_table_path(
      tournament_id: params[:tournament_id], round_id: params[:round_id], number: params[:id]
    )
  end

  def update
    if @round.finished?
      render_with_errors :edit, errors: ['Already finished']
      return
    end

    err_msgs = @table.update_scores(params[:scores])

    if !err_msgs.empty?
      render_with_errors :edit, errors: err_msgs
    else
      flash[:success] = "Table #{@table.number} was updated!"
      redirect_to edit_tournament_round_path(tournament_id: @tournament.id, id: @round.number)
    end
  end
end

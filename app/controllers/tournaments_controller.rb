class TournamentsController < ApplicationController
  before_action only: %i[show update] do
    @tournament = Tournament.find(params[:id])
  end

  def index
    @tournaments = Tournament.all
  end

  def new
  end

  def create
    check_auth('admin', fall_back: :new) || return

    players = params[:players].each_line.map(&:strip).reject(&:blank?)

    t = Tournament.create_with_players(players, params[:total_vp_used], params[:rank_history_used])
    flash[:success] = "New tournament #{t.id} is created"
    redirect_to tournament_path(id: t.id)
  rescue StandardError => e
    render_with_errors :new, errors: [e.message]
  end

  def show
    render_show
  end

  def update
    unless authorized?('admin')
      render_show(errors: ['Not permitted operation'])
      return
    end

    status, message = if params[:dropout]
                        Player.find(params[:dropout]).dropout
                      else
                        @tournament.rollback
                      end

    if status
      flash[:success] = message
    else
      @errors = [message]
    end

    render_show
  end

  private

  def render_show(errors: nil)
    @errors ||= errors
    @ranking = @tournament.ranking
    @ongoing_round = @tournament.ongoing_round

    player_ids = Player.where(tournament_id: @tournament.id).ids

    @scores = Score.where(player_id: player_ids).group_by(&:player_id)
    player_ids.each do |id|
      @scores[id] ||= []
    end

    @scores.each do |_id, scores|
      scores.pop([scores.size - @tournament.finished_count, 0].max)
    end

    render :show
  end
end

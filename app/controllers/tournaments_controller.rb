class TournamentsController < ApplicationController
  before_action only: %i[show update] do
    @tournament = Tournament.find(params[:id])
  end

  before_action only: %i[dropout] do
    @tournament = Tournament.find(params[:tournament_id])
    @player = Player.find(params[:id])
  end

  before_action only: %i[create] do
    check_auth('admin', fall_back: :new)
  end

  before_action only: %i[update dropout] do
    render_show(errors: ['Not permitted operation']) if !authorized?('admin')
  end

  def index
    @tournaments = Tournament.all
  end

  def new
  end

  def create
    players = params[:players].each_line.map(&:strip).reject(&:blank?)

    t = Tournament.create_with_players(players, params[:total_vp_used], params[:rank_history_used], false)
    flash[:success] = "New tournament #{t.id} is created"
    redirect_to tournament_path(id: t.id)
  rescue StandardError => e
    render_with_errors :new, errors: [e.message]
  end

  def show
    render_show
  end

  def update
    status, message = @tournament.rollback!

    if status
      flash[:success] = message
    else
      @errors = [message]
    end

    render_show
  end

  def dropout
    status, message = @player.dropout

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

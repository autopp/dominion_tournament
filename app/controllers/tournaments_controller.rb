class TournamentsController < ApplicationController
  def index
    @tournaments = Tournament.all
  end

  def new
  end

  def create
    players = params[:players].each_line.map(&:strip).reject(&:blank?)

    if players.empty?
      @errors = ['no player given']
      render :new
      return
    end

    t = Tournament.create_with_players(players)
    flash[:success] = "New tournament #{t.id} is created"
    redirect_to tournament_path(id: t.id)

  rescue => e
    @errors = [e.message]
    render :new
  end

  def show
    @tournament = Tournament.find(params[:id])
    @ranking = @tournament.ranking
    @ongoing_round = @tournament.ongoing_round
    render :show
  end
end

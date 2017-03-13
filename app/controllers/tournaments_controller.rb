class TournamentsController < ApplicationController
  def index
    @tournaments = Tournament.all
  end

  def new
  end

  def create
    players = params[:players].each_line.map(&:strip).reject(&:blank?)
    t = Tournament.new
    ActiveRecord::Base.transaction do
      t.save!
      players.each do |name|
        t.players.create!(name: name)
      end
    end

    redirect_to tournament_path(id: t.id)
  end

  def show
  end
end

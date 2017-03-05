class TournamentsController < ApplicationController
  def index
    @tournaments = Tournament.all
  end

  def new
  end

  def create
  end

  def show
  end
end

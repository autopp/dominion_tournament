class RoundsController < ApplicationController
  def create
    @tournament = Tournament.find(params[:tournament_id])
    ActiveRecord::Base.transaction do
      @round = create_round(@tournament)
    end

    redirect_to edit_tournament_round_path(tournament_id: @tournament.id, id: @round.number)
  end

  def show
  end

  def index
  end

  def edit
    @round = Round.find_by(tournament_id: params[:tournament_id], number: params[:id])
  end

  def update
  end

  private

  def create_round(tournament)
    round = tournament.rounds.create!(number: tournament.rounds.count + 1)
    tournament.matchings.each.with_index(1) do |players, i|
      table = round.tables.create!(number: i)
      players.each do |player|
        table.scores.create!(player: player)
      end
    end

    round
  end
end

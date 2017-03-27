class Tournament < ApplicationRecord
  has_many :players, dependent: :destroy
  has_many :rounds, dependent: :destroy

  def ranking
    sorted = players.group_by(&:ranking_value).sort_by { |k, _| k }

    rank = 1
    sorted.reverse.each_with_object([]) do |(_, players), ranking|
      players.sort_by(&:id).each { |player| ranking << { rank: rank, player: player } }
      rank += players.size
    end
  end

  def ongoing_round
    rounds.count > finished_count ? rounds.last : nil
  end

  def matchings
    sorted_players = ranking.map { |hash| hash[:player] }
    three_players_table_size = (4 - sorted_players.size) % 4
    four_players_table_size = (sorted_players.size + 3) / 4 - three_players_table_size

    matchings = []
    sorted_players.take(four_players_table_size * 4).each_slice(4) do |players|
      matchings << players
    end

    sorted_players.drop(four_players_table_size * 4).each_slice(3) do |players|
      matchings << players
    end

    matchings
  end

  def rollback
    msg = ActiveRecord::Base.transaction do
      if ongoing_round
        delete_ongoring_round!
        "Round #{finished_count + 1} is deleted"
      else
        Round.find_by(tournament_id: id, number: finished_count).rollback!
        self.finished_count -= 1
        save!
        "Round #{finished_count + 1} backed to ongoing"
      end
    end

    [true, msg]
  rescue => e
    logger.error(e.message)
    logger.error(e.backtrace.join("\n"))
    [false, e.message]
  end

  def self.create_with_players(player_names)
    t = new
    ActiveRecord::Base.transaction do
      t.save!
      player_names.each do |name|
        t.players.create!(name: name)
      end
    end
    t
  end

  private

  def delete_ongoring_round!
    ongoing_round.destroy!
  end
end

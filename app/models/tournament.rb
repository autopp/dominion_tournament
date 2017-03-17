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
end

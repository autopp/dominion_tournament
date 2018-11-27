class Tournament < ApplicationRecord
  has_many :players, dependent: :destroy
  has_many :rounds, dependent: :destroy

  INVALID_PLAYER_COUNTS = [0, 1, 2, 5].freeze

  def ranking
    grouped_scores = players.includes(:scores).group_by do |p|
      p.ranking_value(total_vp_used, rank_history_used)
    end

    rank = 1
    grouped_scores.sort_by { |k, _| k }.reverse.each_with_object([]) do |(_, players), ranking|
      sorted = players.sort_by do |player|
        total_vp_used ? player.id : player.digest
      end
      sorted.each { |player| ranking << { rank: rank, player: player } }
      rank += players.size
    end
  end

  def ongoing_round
    rounds.count > finished_count ? rounds.last : nil
  end

  def matchings
    sorted_players = ranking.map { |hash| hash[:player] }.reject(&:droped_round)
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
        restore_players!
        self.finished_count -= 1 if finished_count > 0
        save!
        "Round #{finished_count + 1} is backed to ongoing"
      end
    end

    [true, msg]
  rescue StandardError => e
    [false, e.message]
  end

  def self.create_with_players(player_names, total_vp_used, rank_history_used)
    count = player_names.count
    unless Tournament.valid_players_count?(count)
      raise "cannot create #{count} player(s) tournament"
    end

    t = new(total_vp_used: total_vp_used || false, rank_history_used: rank_history_used || false)
    ActiveRecord::Base.transaction do
      t.save!
      player_names.each do |name|
        t.players.create!(name: name)
      end
    end
    t
  end

  def self.valid_players_count?(count)
    !INVALID_PLAYER_COUNTS.include?(count)
  end

  private

  def delete_ongoring_round!
    ongoing_round.destroy!
  end

  def restore_players!
    Player.where(tournament_id: id, droped_round: finished_count).find_each do |player|
      player.update!(droped_round: nil)
    end
  end
end

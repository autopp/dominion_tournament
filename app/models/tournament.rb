class Tournament < ApplicationRecord
  has_many :players, dependent: :destroy
  has_many :scores, through: :players

  INVALID_PLAYER_COUNTS = [0, 1, 2, 5].freeze

  attr_reader :rounds

  after_find :bind_rounds, unless: :rounds
  after_create :bind_rounds, unless: :rounds

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
    has_ongoing_round ? rounds.last : nil
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
        back_to_ongoing!
        "Round #{finished_count + 1} is backed to ongoing"
      end
    end

    [true, msg]
  rescue StandardError => e
    [false, e.message]
  end

  def self.create_with_players(player_names, total_vp_used, rank_history_used)
    count = player_names.count
    raise "cannot create #{count} player(s) tournament" unless Tournament.valid_players_count?(count)

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

  def bind_rounds
    @rounds = (1..finished_count).map do |round_number|
      Round.new(tournament: self, number: round_number)
    end

    @rounds << Round.new(tournament: self, number: finished_count + 1) if has_ongoing_round
  end

  def delete_ongoring_round!
    self.has_ongoing_round = false
    save!
  end

  def back_to_ongoing!
    rounds.last.rollback!
    restore_players!
    self.finished_count -= 1 if finished_count > 0
    self.has_ongoing_round = true
    save!
  end

  def restore_players!
    Player.where(tournament_id: id, droped_round: finished_count).find_each do |player|
      player.update!(droped_round: nil)
    end
  end
end

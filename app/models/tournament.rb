class Tournament < ApplicationRecord
  has_many :players, dependent: :destroy
  has_many :scores, through: :players

  INVALID_PLAYER_COUNTS = [0, 1, 2, 5].freeze

  attr_reader :rounds

  after_find :bind_rounds!, unless: :rounds
  after_create :bind_rounds!, unless: :rounds

  # Returns current ranking
  #
  # @return [Array<Hash>]
  #
  def ranking
    grouped_scores = players.includes(:scores).group_by do |p|
      p.ranking_value(total_vp_used, rank_history_used)
    end

    rank = 1
    grouped_scores.sort_by { |k, _| k }.reverse.each_with_object([]) do |(_, players), ranking|
      sorted = players.sort_by { |player| total_vp_used ? player.id : player.digest }
      sorted.each { |player| ranking << { rank: rank, player: player } }
      rank += players.size
    end
  end

  def ongoing_round
    has_ongoing_round ? rounds.last : nil
  end

  # Returns matchings
  #
  # @return [Array<Array<Player>>]
  #
  def matchings
    sorted_players = sorted_players_for_matchings
    three_players_table_size = (4 - sorted_players.size) % 4
    four_players_table_size = (sorted_players.size + 3) / 4 - three_players_table_size

    matchings = sorted_players.take(four_players_table_size * 4).each_slice(4).to_a
    matchings += sorted_players.drop(four_players_table_size * 4).each_slice(3).to_a

    matchings
  end

  def rollback!
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

  def start_round!
    raise 'ongoing round exists' if has_ongoing_round

    ActiveRecord::Base.transaction do
      number = finished_count + 1
      matchings.each.with_index(1) do |players, i|
        players.each do |player|
          Score.create!(tournament: self, player: player, round_number: number, table_number: i)
        end
      end
      self.has_ongoing_round = true
      save!

      Round.new(tournament: self, number: number)
    end
  end

  def self.create_with_players(player_names, total_vp_used, rank_history_used, randomize_matchings)
    count = player_names.count
    raise "cannot create #{count} player(s) tournament" unless Tournament.valid_players_count?(count)

    t = new(
      total_vp_used: total_vp_used || false,
      rank_history_used: rank_history_used || false,
      randomize_matchings: randomize_matchings || false
    )
    ActiveRecord::Base.transaction do
      t.save!
      player_names.each { |name| t.players.create!(name: name) }
    end
    t
  end

  def self.valid_players_count?(count)
    !INVALID_PLAYER_COUNTS.include?(count)
  end

  private

  def bind_rounds!
    @rounds = (1..finished_count).map { |round_number| Round.new(tournament: self, number: round_number) }

    @rounds << Round.new(tournament: self, number: finished_count + 1) if has_ongoing_round
  end

  def sorted_players_for_matchings
    players = ranking.map { |hash| hash[:player] }.reject(&:droped_round)
    return players if !randomize_matchings

    players.group_by(&:total_tp).sort_by(&:first).reverse.flat_map { |_tp, ps| ps.shuffle }
  end

  def delete_ongoring_round!
    scores.where(round_number: finished_count + 1).destroy_all
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

class Player < ApplicationRecord
  belongs_to :tournament
  has_many :scores, dependent: :destroy

  def total_tp
    finished_scores.map(&:tp).reduce(0, &:+)
  end

  def total_vp
    finished_scores.map(&:vp).reduce(0, &:+)
  end

  def ranking_value
    [total_tp, total_vp] + rank_history
  end

  def rank_history
    finished_scores.each_with_object([0, 0, 0, 0]).each do |score, history|
      history[score.rank - 1] += 1
    end
  end

  def finished_scores
    scores.take(tournament.finished_count)
  end

  def dropout
    unless Tournament.valid_players_count?(tournament.players.count - 1)
      return [false, "#{name} cannot drop (Too few players)"]
    end

    self.droped_round = tournament.finished_count
    status = save

    message = status ? "#{name} is droped out" : "#{name} cannot drop"
    [status, message]
  end
end

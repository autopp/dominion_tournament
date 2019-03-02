require 'digest/md5'

class Player < ApplicationRecord
  belongs_to :tournament
  has_many :scores, dependent: :destroy

  def total_tp
    finished_scores.map(&:tp).reduce(0, &:+)
  end

  def total_vp
    finished_scores.map(&:vp).reduce(0, &:+)
  end

  def ranking_value(total_vp_used, rank_history_used)
    v = [total_tp]
    v << total_vp if total_vp_used
    v += rank_history if rank_history_used
    v
  end

  def digest
    Digest::MD5.hexdigest("#{total_vp}#{name}")
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
    if !Tournament.valid_players_count?(tournament.players.count - 1)
      return [false, "#{name} cannot drop (Too few players)"]
    end

    self.droped_round = tournament.finished_count
    status = save

    message = status ? "#{name} is dropped out" : "#{name} cannot drop"
    [status, message]
  end
end

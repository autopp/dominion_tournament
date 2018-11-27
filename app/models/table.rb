class Table < ApplicationRecord
  belongs_to :round
  has_many :scores, -> { includes(:player) }, dependent: :destroy, inverse_of: :table

  DISTRIBUTION_OF_VPS = [6, 3, 1, 0].freeze

  def aggregate
    sorted_scores = scores.group_by { |s| [s.vp, s.has_extra_turn] }.sort_by do |(vp, extra), _|
      [vp, extra ? 0 : 1]
    end.reverse

    offset = 0
    sorted_scores.each_with_object({}) do |(_, scores), ret|
      sum = DISTRIBUTION_OF_VPS[offset, scores.size].reduce(&:+)
      ret[Rational(sum, scores.size)] = scores
      offset += scores.size
    end
  end

  def finish!
    rank = 1
    aggregate.each do |tp, scores|
      scores.each do |score|
        score.update!(rank: rank, tp_numerator: tp.numerator, tp_denominator: tp.denominator)
      end
      rank += scores.count
    end
  end
end

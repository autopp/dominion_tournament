class Table
  include ActiveModel::Model

  DISTRIBUTION_OF_VPS = [6, 3, 1, 0].freeze

  attr_accessor :tournament, :round_number, :number, :scores

  define_model_callbacks :initialize

  def initialize(*args)
    run_callbacks :initialize do
      super
    end
  end

  after_initialize do
    @scores ||= Score.where(tournament: tournament, round_number: round_number, table_number: number).includes(:player)
  end

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

class Score < ApplicationRecord
  belongs_to :player
  belongs_to :table

  include Comparable

  def vp
    Rational(vp_numerator, vp_denominator)
  end

  def tp
    Rational(tp_numerator, tp_denominator)
  end

  def <=>(other)
    raise TypeError, "operand is not a Score (#{other.inspect})" unless other.is_a?(Score)

    diff = vp - other.vp

    return diff unless diff.zero?

    if has_extra_turn? == other.has_extra_turn?
      0
    else
      has_extra_turn? ? -1 : 1
    end
  end

  def ==(other)
    vp == other.vp && has_extra_turn == other.has_extra_turn
  end
end

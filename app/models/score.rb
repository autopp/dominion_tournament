class Score < ApplicationRecord
  belongs_to :player
  belongs_to :table

  include Comparable

  def vp
    vp_numerator && vp_denominator ? Rational(vp_numerator, vp_denominator) : nil
  end

  def tp
    tp_numerator && tp_denominator ? Rational(tp_numerator, tp_denominator) : nil
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

  def vp_text(player_num)
    return '' unless vp_numerator
    (vp * 4 / player_num).to_i.to_s
  end

  def update_by_input(input, player_num)
    params = { has_extra_turn: input[:has_extra_turn] }
    vp = input[:vp]
    if vp.blank?
      params.merge!(vp_numerator: nil, vp_denominator: nil)
    elsif vp =~ /\A\d+\z/
      vp = vp.to_r * player_num / 4
      params.merge!(vp_numerator: vp.numerator, vp_denominator: vp.denominator)
    else
      return [false, "vp should be blank or integer (given '#{vp}')"]
    end

    [update(params), 'Update Error']
  end

  def complete?
    vp_numerator && vp_denominator
  end
end

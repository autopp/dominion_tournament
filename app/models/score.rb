class Score < ApplicationRecord
  belongs_to :tournament
  belongs_to :player

  include Comparable

  def vp
    vp_numerator && vp_denominator ? Rational(vp_numerator, vp_denominator) : nil
  end

  def tp
    tp_numerator && tp_denominator ? Rational(tp_numerator, tp_denominator) : nil
  end

  def vp_text(player_num, total_vp_used)
    return '' unless vp_numerator

    if total_vp_used
      (vp * 4 / player_num).to_i.to_s
    else
      vp.to_i.to_s
    end
  end

  def update_by_input(input, player_num, total_vp_used)
    params = { has_extra_turn: input[:has_extra_turn] }
    vp = input[:vp]
    if vp.blank?
      params.merge!(vp_numerator: nil, vp_denominator: nil)
    elsif vp.match?(/\A[-+]?\d+\z/)
      vp = vp.to_r
      vp = vp * player_num / 4 if total_vp_used
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

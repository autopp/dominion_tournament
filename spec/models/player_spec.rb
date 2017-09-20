require 'rails_helper'

RSpec.describe Player, type: :model do
  let(:player) { Player.new(name: 'autopp') }

  let(:score1) do
    Score.new(
      vp_numerator: 30, vp_denominator: 1,
      tp_numerator: 6, tp_denominator: 1, rank: 1
    )
  end

  let(:score2) do
    Score.new(
      vp_numerator: 20, vp_denominator: 1,
      tp_numerator: 3, tp_denominator: 1, rank: 2
    )
  end

  let(:score3) do
    Score.new(
      vp_numerator: 30, vp_denominator: 1,
      tp_numerator: 9, tp_denominator: 2, rank: 1
    )
  end

  let(:score4) do
    Score.new(vp_numerator: 25, vp_denominator: 1)
  end

  before do
    score1.player = score2.player = score3.player = score4.player = player
    player.scores << score1 << score2 << score3 << score4
    player.tournament = Tournament.new(id: 1, finished_count: 3)
  end

  describe '#total_tp' do
    subject { player.total_tp }

    it { is_expected.to eq(Rational(27, 2)) }
  end
end

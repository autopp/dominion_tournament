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

  describe '#total_vp' do
    subject { player.total_vp }

    it { is_expected.to eq(Rational(80, 1)) }
  end

  describe '#digest' do
    subject { player.digest }

    it { is_expected.to be_a(String) }
  end

  describe '#ranking_value' do
    subject { player.ranking_value(total_vp_used, rank_history_used) }

    context 'when total vp used' do
      let(:total_vp_used) { true }

      context 'and when rank history used' do
        let(:rank_history_used) { true }

        it { is_expected.to eq([Rational(27, 2), Rational(80, 1), 2, 1, 0, 0]) }
      end

      context 'and when not rank history used' do
        let(:rank_history_used) { false }

        it { is_expected.to eq([Rational(27, 2), Rational(80, 1)]) }
      end
    end

    context 'when not total vp used' do
      let(:total_vp_used) { false }

      context 'and when rank history used' do
        let(:rank_history_used) { true }

        it { is_expected.to eq([Rational(27, 2), 2, 1, 0, 0]) }
      end

      context 'and when not rank history used' do
        let(:rank_history_used) { false }

        it { is_expected.to eq([Rational(27, 2)]) }
      end
    end
  end

  describe '#rank_history' do
    subject { player.rank_history }

    it { is_expected.to eq([2, 1, 0, 0]) }
  end

  describe 'finished_scores' do
    subject { player.finished_scores }

    it 'returns array of score finished' do
      expect(subject).to eq([score1, score2, score3])
    end
  end
end

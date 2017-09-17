require 'rails_helper'

RSpec.describe Score, type: :model do
  let(:score) do
    described_class.new(
      vp_numerator: vp_numerator, vp_denominator: vp_denominator,
      tp_numerator: tp_numerator, tp_denominator: tp_denominator
    )
  end

  let(:vp_numerator) { nil }
  let(:vp_denominator) { nil }
  let(:tp_numerator) { nil }
  let(:tp_denominator) { nil }

  describe '#vp' do
    subject { score.vp }

    context 'both numerator and denominator are given' do
      let(:vp_numerator) { 42 }
      let(:vp_denominator) { 1 }

      it { is_expected.to eq(Rational(42, 1)) }
    end

    context 'when any of numerator or denominator are not given' do
      it { is_expected.to be_nil }
    end
  end

  describe '#tp' do
    subject { score.tp }

    context 'both numerator and denominator are given' do
      let(:tp_numerator) { 9 }
      let(:tp_denominator) { 2 }

      it { is_expected.to eq(Rational(9, 2)) }
    end

    context 'when any of numerator or denominator are not given' do
      it { is_expected.to be_nil }
    end
  end

  describe '#<=>' do
    subject { score <=> other }

    let(:vp_numerator) { 42 }
    let(:vp_denominator) { 1 }

    context 'when other is smaller' do
      let(:other) { described_class.new(vp_numerator: 41, vp_denominator: 1) }

      it { is_expected.to be > 0 }
    end

    context 'when other is greater' do
      let(:other) { described_class.new(vp_numerator: 43, vp_denominator: 1) }

      it { is_expected.to be < 0 }
    end

    context 'when other is equal' do
      context 'and when other dose not has extra turn' do
        let(:other) { described_class.new(vp_numerator: 42, vp_denominator: 1) }

        it { is_expected.to be_zero }
      end

      context 'and when other dose not has extra turn' do
        let(:other) do
          described_class.new(vp_numerator: 42, vp_denominator: 1, has_extra_turn: true)
        end

        it { is_expected.to be > 0 }
      end
    end
  end
end

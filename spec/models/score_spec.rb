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

  describe '#vp_text' do
    subject { score.vp_text(3, total_vp_used) }

    context 'when numerator is not given' do
      let(:total_vp_used) { true }
      it { is_expected.to eq('') }
    end

    context 'when numerator and denominator are given' do
      let(:vp_numerator) { 30 }
      let(:vp_denominator) { 1 }

      context 'and total vp used' do
        let(:total_vp_used) { true }

        it { is_expected.to eq('40') }
      end

      context 'and not total vp used' do
        let(:total_vp_used) { false }

        it { is_expected.to eq('30') }
      end
    end
  end

  describe '#update_by_input' do
    subject { score.update_by_input(input, 3, total_vp_used) }

    let(:input) { { vp: vp, has_extra_turn: true } }

    context 'when vp in input is black' do
      let(:vp) { '' }
      let(:total_vp_used) { true }
      let(:vp_numerator) { nil }
      let(:vp_denominator) { nil }

      before do
        params = {
          has_extra_turn: true,
          vp_numerator: vp_numerator, vp_denominator: vp_denominator
        }
        expect(score).to receive(:update).with(params).and_return(true)
      end

      it { is_expected.to eq([true, 'Update Error']) }
    end

    context 'when vp is given' do
      let(:vp) { '30' }

      before do
        params = {
          has_extra_turn: true,
          vp_numerator: vp_numerator, vp_denominator: vp_denominator
        }
        expect(score).to receive(:update).with(params).and_return(true)
      end

      context 'and total vp is used' do
        let(:total_vp_used) { true }
        let(:vp_numerator) { 45 }
        let(:vp_denominator) { 2 }

        it { is_expected.to eq([true, 'Update Error']) }
      end

      context 'and total vp is not used' do
        let(:total_vp_used) { false }
        let(:vp_numerator) { 30 }
        let(:vp_denominator) { 1 }

        it { is_expected.to eq([true, 'Update Error']) }
      end
    end

    context 'when vp is given but not integer' do
      let(:vp) { 'abc' }
      let(:total_vp_used) { true }

      it { is_expected.to eq([false, "vp should be blank or integer (given 'abc')"]) }
    end
  end

  describe '#complete?' do
    subject { score.complete? }

    context 'when vp is given' do
      let(:vp_numerator) { 42 }
      let(:vp_denominator) { 1 }

      it { is_expected.to be_truthy }
    end

    context 'when vp is not given' do
      it { is_expected.to be_falsy }
    end
  end
end

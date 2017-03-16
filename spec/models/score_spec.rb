require 'rails_helper'

RSpec.describe Score, type: :model do
  let(:score) { described_class.new(vp_numerator: 42, vp_denominator: 1) }

  describe '#<=>' do
    subject { score <=> other }

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

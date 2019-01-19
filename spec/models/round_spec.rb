require 'rails_helper'

describe Round, type: :model do
  describe 'finished?' do
    subject { round.finished? }

    context 'when own number equals to or greater than finished count of tournament' do
      let(:round) do
        described_class.new(tournament: Tournament.new(id: 1, finished_count: 2), number: 2)
      end

      it { is_expected.to be_truthy }
    end

    context 'when own number is less than finished count of tournament' do
      let(:round) do
        described_class.new(tournament: Tournament.new(id: 1, finished_count: 2), number: 3)
      end

      it { is_expected.to be_falsey }
    end
  end
end

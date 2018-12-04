require 'rails_helper'

describe Round, type: :model do
  describe 'finished?' do
    subject { round.finished? }

    context 'when own number equals to or greater than finished count of tournament' do
      let(:round) do
        t = create(:tournament_with_finished_two_rounds)
        t.rounds.first
      end

      it { is_expected.to be_truthy }
    end

    context 'when own number is less than finished count of tournament' do
      let(:round) do
        t = create(:tournament_with_ongoing_third_rounds)
        t.rounds.last
      end

      it { is_expected.to be_falsey }
    end
  end
end

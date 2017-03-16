require 'rails_helper'

RSpec.describe 'tournament page', type: :feature do
  context 'when ongoing rounds dose not exist' do
    before do
      create(:tournament_with_finished_two_rounds)
      visit tournament_path(id: 1)
    end

    context 'when click "Start new round"' do
      before { click_on 'Start new round' }

      it 'redirect to /tournaments/1/rounds/3/edit' do
        expect(current_path).to eq(edit_tournament_round_path(tournament_id: 1, id: 3))
      end

      it 'create new round' do
        expect(Round.last.attributes).to include(tournament_id: 1, number: 3)
      end
    end
  end

  context 'when ongoing round exists' do
    before do
      create(:tournament_with_ongoing_third_rounds)
      visit tournament_path(id: 1)
    end

    let(:edit_round_path) { edit_tournament_round_path(tournament_id: 1, id: 3) }
    subject { page }

    it { is_expected.to have_link('Current round', href: edit_round_path) }
  end
end

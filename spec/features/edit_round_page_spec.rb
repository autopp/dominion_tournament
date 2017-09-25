require 'rails_helper'

RSpec.describe 'round editing page', type: :feature do
  before do
    @tournament = create(:tournament_with_ongoing_third_rounds)
  end

  context 'when round is already finished' do
    it 'redirect to show page' do
      visit edit_tournament_round_path(tournament_id: 1, id: 2)
      expect(current_path).to eq(tournament_round_path(tournament_id: 1, id: 2))
    end
  end

  context 'when authority level is not "admin"' do
    include_context 'authority level is "staff"'

    scenario 'click finish' do
      visit edit_tournament_round_path(tournament_id: 1, id: 3)

      click_on 'Finish'

      expect(current_path).to eq(tournament_round_path(tournament_id: 1, id: 3))
      expect(@tournament.finished_count).to eq(2)
      expect(page).to have_css('div', id: 'error_explanation')
    end
  end
end

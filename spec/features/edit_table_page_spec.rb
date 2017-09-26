require 'rails_helper'

RSpec.describe 'round editing page', type: :feature do
  before { create(:tournament_with_ongoing_third_rounds) }

  context 'when round is already finished' do
    it 'redirect to show page' do
      visit edit_tournament_round_table_path(tournament_id: 1, round_id: 2, id: 1)
      expect(current_path).to eq(tournament_round_table_path(tournament_id: 1, round_id: 2, id: 1))
    end
  end

  context 'when authority level is not "staff"' do
    include_context 'authority level is "guest"'

    scenario 'click save' do
      visit edit_tournament_round_table_path(tournament_id: 1, round_id: 3, id: 1)

      click_on 'Save'

      expect(current_path).to eq(tournament_round_table_path(tournament_id: 1, round_id: 3, id: 1))
      expect(page).to have_css('div', id: 'error_explanation')
    end
  end
end

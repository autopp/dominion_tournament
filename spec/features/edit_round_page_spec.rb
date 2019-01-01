require 'rails_helper'

RSpec.describe 'round editing page', type: :feature do
  before do
    @tournament = create(:tournament_with_ongoing_third_rounds)
  end

  let(:page_path) { edit_tournament_round_path(tournament_id: @tournament.id, id: round_number) }

  context 'when round is already finished' do
    let(:round_number) { 2 }

    it 'redirect to show page' do
      visit page_path
      expect(current_path).to eq(tournament_round_path(tournament_id: @tournament.id, id: round_number))
    end
  end

  context 'when authority level is not "admin"' do
    include_context 'authority level is "staff"'

    let(:round_number) { 3 }

    scenario 'click finish' do
      visit page_path

      click_on 'Finish'

      expect(current_path).to eq(tournament_round_path(tournament_id: @tournament.id, id: round_number))
      expect(@tournament.finished_count).to eq(2)
      expect(page).to have_error_explanation
    end
  end
end

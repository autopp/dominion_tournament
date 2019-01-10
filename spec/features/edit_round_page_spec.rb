require 'rails_helper'

RSpec.describe 'round editing page', type: :feature do
  let(:tournament) { create(:tournament_with_ongoing_third_rounds) }

  before do
    @tournament = tournament
  end

  let(:page_path) { edit_tournament_round_path(tournament_id: @tournament.id, id: round_number) }

  context 'when round is already finished' do
    let(:round_number) { 2 }

    scenario 'redirect to show page' do
      visit page_path
      expect(current_path).to eq(tournament_round_path(tournament_id: @tournament.id, id: round_number))
    end
  end

  context 'when authority level is not "admin"', auth: :staff do
    let(:round_number) { 3 }

    scenario 'click finish' do
      visit page_path

      click_on 'Finish'

      expect(current_path).to eq(tournament_round_path(tournament_id: @tournament.id, id: round_number))
      expect(@tournament.finished_count).to eq(2)
      expect(page).to have_error_explanation
    end
  end

  context 'when authority level is "admin"' do
    let(:tournament) { create(:tournament_with_input_completed_two_rounds) }
    let(:round_number) { 2 }

    scenario 'click finish' do
      visit page_path

      click_on 'Finish'
    end
  end
end

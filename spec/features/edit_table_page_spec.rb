require 'rails_helper'

RSpec.describe 'round editing page', type: :feature do
  before { @tournament = create(:tournament_with_ongoing_third_rounds) }
  let(:page_path) do
    edit_tournament_round_table_path(tournament_id: @tournament.id, round_id: round_number, id: table_number)
  end

  context 'when round is already finished' do
    let(:round_number) { 2 }
    let(:table_number) { 1 }

    it 'redirect to show page' do
      visit page_path
      redirected_oath = tournament_round_table_path(
        tournament_id: @tournament.id, round_id: round_number, id: table_number
      )
      expect(current_path).to eq(redirected_oath)
    end
  end

  context 'when authority level is not "staff"' do
    include_context 'authority level is "guest"'

    let(:round_number) { 3 }
    let(:table_number) { 1 }

    scenario 'click save' do
      visit page_path

      click_on 'Save'

      expect(current_path).to eq(page_path)
      expect(page).to have_css('div', id: 'error_explanation')
    end
  end

  context 'when authority level is "staff"' do
    include_context 'authority level is "staff"'

    let(:round_number) { 3 }
    let(:table_number) { 2 }

    scenario 'input score and click save' do
      visit page_path

      find('#score_1_vp').set('20')
      find('#score_1_has_extra_turn').set(true)
      click_on 'Save'

      expect(current_path).to eq(edit_tournament_round_path(tournament_id: @tournament.id, id: round_number))
      expect(page).not_to have_css('div', id: 'error_explanation')
      expect(page).to have_css('div', id: 'flash-message-success')
      expect(find("#score_#{table_number}_1_vp").text).to eq('20')
      expect(find("#score_#{table_number}_1_has_extra_turn").checked?).to eq(true)
    end
  end
end

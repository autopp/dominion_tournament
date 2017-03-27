require 'rails_helper'

RSpec.describe 'round editing page', type: :feature do
  before { create(:tournament_with_ongoing_third_rounds) }

  context 'when round is already finished' do
    it 'redirect to show page' do
      visit edit_tournament_round_path(tournament_id: 1, id: 2)
      expect(current_path).to eq(tournament_round_path(tournament_id: 1, id: 2))
    end
  end
end

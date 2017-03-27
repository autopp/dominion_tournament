require 'rails_helper'

RSpec.describe 'round page', type: :feature do
  before { create(:tournament_with_ongoing_third_rounds) }

  context 'when round is not finished yet' do
    it 'redirect to edit page' do
      visit tournament_round_path(tournament_id: 1, id: 3)
      expect(current_path).to eq(edit_tournament_round_path(tournament_id: 1, id: 3))
    end
  end
end

require 'rails_helper'

RSpec.describe 'table page', type: :feature do
  before { create(:tournament_with_ongoing_third_rounds) }

  context 'when round is not finished yet' do
    it 'redirect to edit page' do
      visit tournament_round_table_path(tournament_id: 1, round_id: 3, id: 1)
      expect(current_path).to eq(
        edit_tournament_round_table_path(tournament_id: 1, round_id: 3, id: 1)
      )
    end
  end
end

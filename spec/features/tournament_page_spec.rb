require 'rails_helper'

RSpec.describe 'tournament page', type: :feature do
  shared_examples 'current score ranking viewer' do
    let(:ranking_rows) { page.all('tr.ranking-row') }

    it 'show ranking table' do
      player_names = ranking_rows.map { |row| row.find('td.ranking-player-name').text }
      expect(player_names).to eq(
        %w(
          player1 player4 player9 player10
          player5 player7 player11 player8
          player3 player6 player2
        )
      )
    end

    it 'show each player result' do
      colmuns = ranking_rows.first.all('td')
      expect(colmuns.map(&:text)).to eq(['1', 'player1', '6, 30VP', '6, 24VP', '12, 54VP'])
    end
  end

  context 'when ongoing rounds dose not exist' do
    before do
      create(:tournament_with_finished_two_rounds)
      visit tournament_path(id: 1)
    end

    it_behaves_like 'current score ranking viewer'

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

    it_behaves_like 'current score ranking viewer'

    let(:edit_round_path) { edit_tournament_round_path(tournament_id: 1, id: 3) }
    subject { page }

    it { is_expected.to have_link('Current round', href: edit_round_path) }
  end
end

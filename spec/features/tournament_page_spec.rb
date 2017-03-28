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
      expected = ['1', 'player1', 'Drop out', '6', '30', '6', '24', '12', '54']
      expect(colmuns.map(&:text)).to eq(expected)
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
        expect(Round.last.attributes).to include('tournament_id' => 1, 'number' => 3)
      end
    end

    context 'and when click rollback' do
      it 'cancel the round 2' do
        click_on 'Rollback'

        expect(page).to have_css('div.alert-success', text: 'Round 2 is backed to ongoing')
        tournament = Tournament.find(1)
        expect(tournament.finished_count).to eq(1)
        expect(tournament.ongoing_round).to eq(Round.find_by(tournament_id: 1, number: 2))
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

    context 'and when click rollback' do
      it 'delete the round 3' do
        click_on 'Rollback'

        expect(page).to have_css('div.alert-success', text: 'Round 3 is deleted')
        expect(Round.find_by(tournament_id: 1, number: 3)).to be_nil
      end
    end
  end
end

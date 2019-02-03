require 'rails_helper'

RSpec.describe 'tournament page', type: :feature do
  shared_examples 'current score ranking viewer' do
    let(:ranking_rows) { page.all('tr.ranking-row') }

    scenario 'show ranking table' do
      player_names = ranking_rows.map { |row| row.find('td.ranking-player-name').text }
      expect(player_names).to eq(
        %w[
          player1 player4 player9 player10
          player5 player7 player11 player8
          player3 player6 player2
        ]
      )
    end

    scenario 'show each player result' do
      colmuns = ranking_rows.first.all('td')
      expected = ['1', 'player1', '', '6', '30', '6', '24', '12', '54']
      expect(colmuns.map(&:text)).to eq(expected)
    end
  end

  context 'when ongoing rounds dose not exist' do
    before do
      @tournament = create(:tournament_with_finished_two_rounds)
      visit tournament_path(id: @tournament.id)
    end

    it_behaves_like 'current score ranking viewer'

    context 'when click "Start new round"' do
      scenario 'redirect to /tournaments/1/rounds/3/edit' do
        click_on 'Start new round'
        expect(current_path).to eq(edit_tournament_round_path(tournament_id: @tournament.id, id: 3))
      end

      context 'when authority level is not admin', auth: :staff do
        scenario 'fails' do
          click_on 'Start new round'
          expect(page).to have_flash_message(:danger)
        end
      end
    end

    context 'and when click rollback' do
      scenario 'cancel the round 2' do
        click_on 'Rollback'

        expect(page).to have_flash_message(:success, text: 'Round 2 is backed to ongoing')

        visit tournament_path(id: @tournament.id)
        expect(page).to have_link(
          'Current round',
          href: edit_tournament_round_path(tournament_id: @tournament.id, id: 2)
        )
      end
    end

    context 'and when click "Drop out" of player1' do
      let(:target_name) { 'player1' }
      let(:target_player) { @tournament.players.find { |p| p.name == target_name } }

      scenario 'player1 is dropped' do
        find("#dropout-player-#{target_player.id}").click

        expect(page).to have_flash_message(:success, text: "#{target_name} is dropped out")
        expect(find("#player-#{target_player.id}-status").value).to eq('Dropped')
      end
    end
  end

  context 'when ongoing round exists' do
    before do
      @tournament = create(:tournament_with_ongoing_third_rounds)
      visit tournament_path(id: @tournament.id)
    end

    it_behaves_like 'current score ranking viewer'

    let(:edit_round_path) { edit_tournament_round_path(tournament_id: @tournament.id, id: 3) }

    scenario 'contains link to the current round' do
      expect(page).to have_link('Current round', href: edit_round_path)
    end

    context 'and when click rollback' do
      scenario 'delete the round 3' do
        click_on 'Rollback'

        expect(page).to have_flash_message(:success, text: 'Round 3 is deleted')
        expect(page).to have_css('#start-new-round')
      end
    end
  end
end

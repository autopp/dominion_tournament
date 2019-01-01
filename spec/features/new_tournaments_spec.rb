require 'rails_helper'

RSpec.feature 'create tournament', type: :feature do
  before do
    create :tournament, :with_two_players
  end

  scenario 'input valid players text and click create' do
    visit new_tournament_path

    input = <<~EOS
      foo

      bar
      baz
    EOS

    fill_in 'players', with: input
    click_on 'Create'

    expect(current_path).to eq(tournament_path(id: 2))
    expect(Tournament.count).to eq(2)
    expect(Player.count).to eq(5)
  end

  scenario 'input invalid players text and click create' do
    visit new_tournament_path

    input = <<~EOS


    EOS

    fill_in 'players', with: input
    click_on 'Create'

    expect(Tournament.count).to eq(1)
    expect(Player.count).to eq(2)
    expect(page).to have_error_explanation
  end

  context 'when authority mode is not "admin"' do
    include_context 'authority level is "staff"'

    scenario 'input valid players text and click create' do
      visit new_tournament_path

      input = <<~EOS
        foo

        bar
        baz
      EOS

      fill_in 'players', with: input
      click_on 'Create'

      expect(current_path).to eq(tournaments_path)
      expect(Tournament.count).to eq(1)
      expect(Player.count).to eq(2)
      expect(page).to have_error_explanation
    end
  end
end

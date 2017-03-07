require 'rails_helper'

feature 'top page', type: :feature do
  before do
    create :tournament
    create :tournament
  end

  scenario 'show links to each tournaments & new tournament page' do
    visit root_path

    expect(page).to have_link('1', href: tournament_path(id: 1))
    expect(page).to have_link('2', href: tournament_path(id: 2))
    expect(page).to have_link('New Tournament', href: new_tournament_path)
  end
end

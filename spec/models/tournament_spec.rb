require 'rails_helper'

RSpec.describe Tournament, type: :model do
  describe '.create_with_players' do
    context 'with ["foo", "bar", "baz"], true, true' do
      let(:names) { %w[foo bar baz] }
      subject { described_class.create_with_players(names, true, true) }

      it { is_expected.to be_a(Tournament) }

      it 'create new tournament record' do
        expect { subject }.to change { Tournament.count }.by(1)
      end

      it 'create related player records' do
        expect { subject }.to change { Player.count }.by(3)
        expect(subject.players.map(&:name)).to eq(names)
      end
    end
  end

  describe '#ongoing_round' do
    subject { tournament.ongoing_round }

    context 'when all rounds are finished' do
      let(:tournament) { create(:tournament_with_finished_two_rounds) }

      it { is_expected.to be_nil }
    end

    context 'when tournament has ongoing round' do
      let(:tournament) { create(:tournament_with_ongoing_third_rounds) }

      it 'returns the ongoing round' do
        is_expected.to have_attributes(tournament_id: tournament.id, number: 3)
      end
    end
  end

  describe '#matchings' do
    let(:tournament) { create(:tournament_with_finished_two_rounds) }

    subject { tournament.matchings.map { |table| table.map(&:name) } }

    it 'returns matchings by ranking' do
      matchings = [
        %w[player1 player4 player9 player10],
        %w[player5 player7 player11 player8],
        %w[player3 player6 player2]
      ]
      expect(subject).to eq(matchings)
    end
  end
end

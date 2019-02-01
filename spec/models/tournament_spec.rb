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

  describe '#ranking' do
    subject { tournament.ranking }

    context 'when all rounds are finished' do
      let(:tournament) { create(:tournament_with_finished_two_rounds) }

      it 'aggregates all scores' do
        ranking = [
          { rank: 1, player: an_object_having_attributes(name: 'player1') },
          { rank: 2, player: an_object_having_attributes(name: 'player4') },
          { rank: 3, player: an_object_having_attributes(name: 'player9') },
          { rank: 3, player: an_object_having_attributes(name: 'player10') },
          { rank: 5, player: an_object_having_attributes(name: 'player5') },
          { rank: 6, player: an_object_having_attributes(name: 'player7') },
          { rank: 7, player: an_object_having_attributes(name: 'player11') },
          { rank: 8, player: an_object_having_attributes(name: 'player8') },
          { rank: 9, player: an_object_having_attributes(name: 'player3') },
          { rank: 9, player: an_object_having_attributes(name: 'player6') },
          { rank: 11, player: an_object_having_attributes(name: 'player2') }
        ]
        expect(subject).to match(ranking)
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
        is_expected.to have_attributes(tournament: tournament, number: 3)
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

  describe '#start_round' do
    subject { tournament.start_round }

    context 'when tournament has ongoing round' do
      let(:tournament) { build(:tournament_with_ongoing_third_rounds) }

      it 'raises error' do
        expect { subject }.to raise_error('ongoing round exists')
      end
    end

    context 'when tournament dose not have ongoing round' do
      let(:tournament) { create(:tournament_with_finished_two_rounds) }

      it 'returns new third rounds' do
        expect(subject).to be_kind_of(Round) & have_attributes(number: 3, tables: a_kind_of(Array))
      end
    end
  end
end

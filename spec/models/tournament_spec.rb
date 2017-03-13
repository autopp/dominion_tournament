require 'rails_helper'

RSpec.describe Tournament, type: :model do
  describe '.create_with_players' do
    context 'with ["foo", "bar"]' do
      let(:names) { %w(foo bar) }
      subject { described_class.create_with_players(names) }

      it { is_expected.to be_a(Tournament) }

      it 'create new tournament record' do
        expect { subject }.to change { Tournament.count }.by(1)
      end

      it 'create related player records' do
        expect { subject }.to change { Player.count }.by(2)
        expect(subject.players.map(&:name)).to eq(names)
      end
    end
  end
end

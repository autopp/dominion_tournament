require 'rails_helper'

RSpec.describe Table, type: :model do
  let(:table) { Table.new(number: 1) }

  describe '#aggregate' do
    subject { table.aggregate }

    let(:player1) { Player.new(name: 'player1') }
    let(:player2) { Player.new(name: 'player2') }
    let(:player3) { Player.new(name: 'player3') }
    let(:player4) { Player.new(name: 'player4') }

    context 'when scores is 9, 8, 7, 6' do
      before do
        table.scores.new(vp_numerator: 9, vp_denominator: 1, player: player1)
        table.scores.new(vp_numerator: 8, vp_denominator: 1, player: player2)
        table.scores.new(vp_numerator: 7, vp_denominator: 1, player: player3)
        table.scores.new(vp_numerator: 6, vp_denominator: 1, player: player4)
      end

      it 'returns { 6 => [player1], 3 => [player2], 1 => [player3], 0 => [player4] }' do
        expect(subject).to eq(
          {
            Rational(6) => [player1], Rational(3) => [player2],
            Rational(1) => [player3], Rational(0) => [player4]
          }
        )
      end
    end

    context 'when scores is 9, 9, 8, 8' do
      before do
        table.scores.new(vp_numerator: 9, vp_denominator: 1, player: player1)
        table.scores.new(vp_numerator: 9, vp_denominator: 1, player: player2)
        table.scores.new(vp_numerator: 8, vp_denominator: 1, player: player3)
        table.scores.new(vp_numerator: 8, vp_denominator: 1, player: player4)
      end

      it 'returns { 9/2 => [player1, player2], 1/2 => [player3, player4] }' do
        expect(subject).to eq(
          {
            Rational(9, 2) => [player1, player2],
            Rational(1, 2) => [player3, player4]
          }
        )
      end
    end
  end
end

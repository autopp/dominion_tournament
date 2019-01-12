require 'rails_helper'

RSpec.describe TableEntity, type: :model do
  let(:tournament) { Tournament.new }
  let(:table) { described_class.new(number: 1, scores: scores) }
  let(:scores) { [score1, score2, score3, score4] }

  let(:player1) { Player.new(tournament: tournament, name: 'player1') }
  let(:player2) { Player.new(tournament: tournament, name: 'player2') }
  let(:player3) { Player.new(tournament: tournament, name: 'player3') }
  let(:player4) { Player.new(tournament: tournament, name: 'player4') }

  describe '#aggregate' do
    subject { table.aggregate }

    context 'when scores is 9, 8, 7, 6' do
      let(:score1) { player1.scores.new(tournament: tournament, vp_numerator: 9, vp_denominator: 1) }
      let(:score2) { player2.scores.new(tournament: tournament, vp_numerator: 8, vp_denominator: 1) }
      let(:score3) { player3.scores.new(tournament: tournament, vp_numerator: 7, vp_denominator: 1) }
      let(:score4) { player4.scores.new(tournament: tournament, vp_numerator: 6, vp_denominator: 1) }

      it 'returns { 6 => [score1], 3 => [score2], 1 => [score3], 0 => [score4] }' do
        expect(subject).to eq(
          {
            Rational(6) => [score1], Rational(3) => [score2],
            Rational(1) => [score3], Rational(0) => [score4]
          }
        )
      end
    end

    context 'when scores is 9, 9, 8, 8' do
      let(:score1) { player1.scores.new(tournament: tournament, vp_numerator: 9, vp_denominator: 1) }
      let(:score2) { player2.scores.new(tournament: tournament, vp_numerator: 9, vp_denominator: 1) }
      let(:score3) { player3.scores.new(tournament: tournament, vp_numerator: 8, vp_denominator: 1) }
      let(:score4) { player4.scores.new(tournament: tournament, vp_numerator: 8, vp_denominator: 1) }

      it 'returns { 9/2 => [score1, score2], 1/2 => [score3, score4] }' do
        expect(subject).to eq(
          {
            Rational(9, 2) => [score1, score2],
            Rational(1, 2) => [score3, score4]
          }
        )
      end
    end
  end

  describe '#finish!' do
    let(:score1) { player1.scores.new(tournament: tournament, vp_numerator: 9, vp_denominator: 1) }
    let(:score2) { player2.scores.new(tournament: tournament, vp_numerator: 9, vp_denominator: 1) }
    let(:score3) { player3.scores.new(tournament: tournament, vp_numerator: 8, vp_denominator: 1) }
    let(:score4) { player4.scores.new(tournament: tournament, vp_numerator: 8, vp_denominator: 1) }

    it 'updates tp and rank of each score' do
      pending
      table.finish!

      expect(score1.attributes).to include('tp_numerator' => 9, 'tp_denominator' => 2, 'rank' => 1)
      expect(score2.attributes).to include('tp_numerator' => 9, 'tp_denominator' => 2, 'rank' => 1)
      expect(score3.attributes).to include('tp_numerator' => 1, 'tp_denominator' => 2, 'rank' => 3)
      expect(score4.attributes).to include('tp_numerator' => 1, 'tp_denominator' => 2, 'rank' => 3)
    end
  end
end

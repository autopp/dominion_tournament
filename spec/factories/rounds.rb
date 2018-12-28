def create_score(factory, *traits, tournament, table, round_number, table_number, player_name)
  player = Player.find_by(name: player_name)
  score = create(factory, *traits,
                 tournament: tournament, table: table,
                 round_number: round_number, table_number: table_number, player: player)
  player.scores << score
  table.scores << score
  score
end

FactoryGirl.define do
  factory :round do
    tournament

    factory :first_finished_round do
      number 1

      after(:create) do |r|
        first_table = create(:table, round: r, number: 1)
        r.tables << first_table
        create_score(:score_30vp, :with_6tp, r.tournament, first_table, 1, 1, 'player1') # 6 30
        create_score(:score_21vp, :with_3tp, r.tournament, first_table, 1, 1, 'player2') # 3 21
        create_score(:score_9vp, :with_0tp, r.tournament, first_table, 1, 1, 'player3')  # 0 9
        create_score(:score_18vp, :with_1tp, r.tournament, first_table, 1, 1, 'player4') # 1 18

        second_table = create(:table, round: r, number: 2)
        r.tables << second_table
        create_score(:score_18vp, :with_6tp, r.tournament, second_table, 1, 2, 'player5')                 # 6 18
        create_score(:score_9vp_with_extra_turn, :with_0tp, r.tournament, second_table, 1, 2, 'player6')  # 0 9
        create_score(:score_9vp, :with_1tp, r.tournament, second_table, 1, 2, 'player7')                  # 1 9
        create_score(:score_18vp_with_extra_turn, :with_3tp, r.tournament, second_table, 1, 2, 'player8') # 3 18

        third_table = create(:table, round: r, number: 3)
        r.tables << third_table
        create_score(:score_30vp, :with_4_5tp, r.tournament, third_table, 1, 3, 'player9')  # 4.5 30
        create_score(:score_30vp, :with_4_5tp, r.tournament, third_table, 1, 3, 'player10') # 4.5 30
        create_score(:score_21vp, :with_1tp, r.tournament, third_table, 1, 3, 'player11')   # 1 21
      end
    end

    factory :second_finished_round do
      number 2

      after(:create) do |r|
        first_table = create(:table, round: r, number: 1)
        r.tables << first_table
        create_score(:score_24vp, :with_6tp, r.tournament, first_table, 2, 1, 'player1')  # 12 54
        create_score(:score_9vp, :with_0tp, r.tournament, first_table, 2, 1, 'player5')   # 6 27
        create_score(:score_18vp, :with_2tp, r.tournament, first_table, 2, 1, 'player9')  # 6.5 48
        create_score(:score_18vp, :with_2tp, r.tournament, first_table, 2, 1, 'player10') # 6.5 48

        second_table = create(:table, round: r, number: 2)
        r.tables << second_table
        create_score(:score_9vp, :with_0tp, r.tournament, second_table, 2, 2, 'player2')                  # 3 30
        create_score(:score_18vp_with_extra_turn, :with_1tp, r.tournament, second_table, 2, 2, 'player8') # 4 16
        create_score(:score_18vp, :with_3tp, r.tournament, second_table, 2, 2, 'player11')                # 4 39
        create_score(:score_30vp, :with_6tp, r.tournament, second_table, 2, 2, 'player4')                 # 7 48

        third_table = create(:table, round: r, number: 3)
        r.tables << third_table
        create_score(:score_30vp, :with_3_3tp, r.tournament, third_table, 2, 3, 'player7') # 4.33 39
        create_score(:score_30vp, :with_3_3tp, r.tournament, third_table, 2, 3, 'player3') # 3.33 39
        create_score(:score_30vp, :with_3_3tp, r.tournament, third_table, 2, 3, 'player6') # 3.33 39
      end
    end

    factory :third_ongoing_round do
      number 3

      after(:create) do |r|
        first_table = create(:table, round: r, number: 1)
        r.tables << first_table
        create_score(:score_24vp, :with_3tp, r.tournament, first_table, 3, 1, 'player1')  # 15 78
        create_score(:score_9vp, :with_0tp, r.tournament, first_table, 3, 1, 'player4')   # 7 57
        create_score(:score_18vp, :with_1tp, r.tournament, first_table, 3, 1, 'player9')  # 7.5 64
        create_score(:score_30vp, :with_6tp, r.tournament, first_table, 3, 1, 'player10') # 12.5 78

        second_table = create(:table, round: r, number: 2)
        r.tables << second_table
        create_score(:score, r.tournament, second_table, 3, 2, 'player5')
        create_score(:score, r.tournament, second_table, 3, 2, 'player7')
        create_score(:score, r.tournament, second_table, 3, 2, 'player11')
        create_score(:score, r.tournament, second_table, 3, 2, 'player8')

        third_table = create(:table, round: r, number: 3)
        r.tables << third_table
        create_score(:score, r.tournament, third_table, 3, 3, 'player3')
        create_score(:score, r.tournament, third_table, 3, 3, 'player6')
        create_score(:score, r.tournament, third_table, 3, 3, 'player2')
      end
    end
  end
end

def create_score(factory, *traits, table, player_name)
  player = Player.find_by(name: player_name)
  score = create(factory, *traits, table: table, player: player)
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
        create_score(:score_30vp, :with_6tp, first_table, 'player1') # 6 30
        create_score(:score_21vp, :with_3tp, first_table, 'player2') # 3 21
        create_score(:score_9vp, :with_0tp, first_table, 'player3')  # 0 9
        create_score(:score_18vp, :with_1tp, first_table, 'player4') # 1 18

        second_table = create(:table, round: r, number: 2)
        r.tables << second_table
        create_score(:score_18vp, :with_6tp, second_table, 'player5')                 # 6 18
        create_score(:score_9vp_with_extra_turn, :with_0tp, second_table, 'player6')  # 0 9
        create_score(:score_9vp, :with_1tp, second_table, 'player7')                  # 1 9
        create_score(:score_18vp_with_extra_turn, :with_3tp, second_table, 'player8') # 3 18

        third_table = create(:table, round: r, number: 3)
        r.tables << third_table
        create_score(:score_30vp, :with_4_5tp, third_table, 'player9')  # 4.5 30
        create_score(:score_30vp, :with_4_5tp, third_table, 'player10') # 4.5 30
        create_score(:score_21vp, :with_1tp, third_table, 'player11')   # 1 21
      end
    end

    factory :second_finished_round do
      number 2

      after(:create) do |r|
        first_table = create(:table, round: r, number: 1)
        r.tables << first_table
        create_score(:score_24vp, :with_6tp, first_table, 'player1')  # 12 54
        create_score(:score_9vp, :with_0tp, first_table, 'player5')   # 6 27
        create_score(:score_18vp, :with_2tp, first_table, 'player9')  # 6.5 48
        create_score(:score_18vp, :with_2tp, first_table, 'player10') # 6.5 48

        second_table = create(:table, round: r, number: 2)
        r.tables << second_table
        create_score(:score_9vp, :with_0tp, second_table, 'player2')                  # 3 30
        create_score(:score_18vp_with_extra_turn, :with_1tp, second_table, 'player8') # 4 16
        create_score(:score_18vp, :with_3tp, second_table, 'player11')                # 4 39
        create_score(:score_30vp, :with_6tp, second_table, 'player4')                 # 7 48

        third_table = create(:table, round: r, number: 3)
        r.tables << third_table
        create_score(:score_30vp, :with_3_3tp, third_table, 'player7') # 4.33 39
        create_score(:score_30vp, :with_3_3tp, third_table, 'player3') # 3.33 39
        create_score(:score_30vp, :with_3_3tp, third_table, 'player6') # 3.33 39
      end
    end

    factory :third_ongoing_round do
      number 3

      after(:create) do |r|
        first_table = create(:table, round: r, number: 1)
        r.tables << first_table
        create_score(:score_24vp, :with_3tp, first_table, 'player1')  # 15 78
        create_score(:score_9vp, :with_0tp, first_table, 'player4')   # 7 57
        create_score(:score_18vp, :with_1tp, first_table, 'player9')  # 7.5 64
        create_score(:score_30vp, :with_6tp, first_table, 'player10') # 12.5 78

        second_table = create(:table, round: r, number: 2)
        r.tables << second_table
        create_score(:score, second_table, 'player5')
        create_score(:score, second_table, 'player7')
        create_score(:score, second_table, 'player11')
        create_score(:score, second_table, 'player8')

        third_table = create(:table, round: r, number: 3)
        r.tables << third_table
        create_score(:score, third_table, 'player3')
        create_score(:score, third_table, 'player6')
        create_score(:score, third_table, 'player2')
      end
    end
  end
end
def bind_scores_of_round(tournament, scores)
  scores.each do |(name, factory, *traits, round_number, table_number)|
    player = tournament.players.find { |p| p.name == name }
    player.scores << build(factory, *traits, round_number: round_number, table_number: table_number, player: player)
  end
end

FactoryGirl.define do
  factory :tournament do
    trait :with_two_players do
      after(:build) do |t|
        t.players << build(:player, name: 'xxx', tournament: t)
        t.players << build(:player, name: 'yyy', tournament: t)
      end
    end

    trait :with_11_players do
      after(:build) do |t|
        11.times do |i|
          t.players << build(:player, name: "player#{i + 1}", tournament: t)
        end
      end
    end

    round1_scores = [
      # table 1
      ['player1', :score_30vp, :with_6tp, 1, 1], # 6 30
      ['player2', :score_21vp, :with_3tp, 1, 1], # 3 21
      ['player3', :score_9vp, :with_0tp, 1, 1],  # 0 9
      ['player4', :score_18vp, :with_1tp, 1, 1], # 1 18
      # table 2
      ['player5', :score_18vp, :with_6tp, 1, 2],                 # 6 18
      ['player6', :score_9vp_with_extra_turn, :with_0tp, 1, 2],  # 0 9
      ['player7', :score_9vp, :with_1tp, 1, 2],                  # 1 9
      ['player8', :score_18vp_with_extra_turn, :with_3tp, 1, 2], # 3 18
      # table 3
      ['player9', :score_30vp, :with_4_5tp, 1, 3],  # 4.5 30
      ['player10', :score_30vp, :with_4_5tp, 1, 3], # 4.5 30
      ['player11', :score_21vp, :with_1tp, 1, 3]    # 1 21
    ]

    round2_scores = [
      # table 1
      ['player1', :score_24vp, :with_6tp, 2, 1],  # 12 54
      ['player5', :score_9vp, :with_0tp, 2, 1],   # 6 27
      ['player9', :score_18vp, :with_2tp, 2, 1],  # 6.5 48
      ['player10', :score_18vp, :with_2tp, 2, 1], # 6.5 48
      # table 2
      ['player2', :score_9vp, :with_0tp, 2, 2],                  # 3 30
      ['player8', :score_18vp_with_extra_turn, :with_1tp, 2, 2], # 4 16
      ['player11', :score_18vp, :with_3tp, 2, 2],                # 4 39
      ['player4', :score_30vp, :with_6tp, 2, 2],                 # 7 48
      # table 3
      ['player7', :score_30vp, :with_3_3tp, 2, 3], # 4.33 39
      ['player3', :score_30vp, :with_3_3tp, 2, 3], # 3.33 39
      ['player6', :score_30vp, :with_3_3tp, 2, 3] # 3.33 39
    ]

    round3_scores = [
      # table 1
      ['player1', :score_24vp, :with_3tp, 3, 1],  # 15 78
      ['player4', :score_9vp, :with_0tp, 3, 1],   # 7 57
      ['player9', :score_18vp, :with_1tp, 3, 1],  # 7.5 64
      ['player10', :score_30vp, :with_6tp, 3, 1], # 12.5 78
      # table 2
      ['player5', :score, 3, 2],
      ['player7', :score, 3, 2],
      ['player11', :score, 3, 2],
      ['player8', :score, 3, 2],
      # table 3
      ['player3', :score, 3, 3],
      ['player6', :score, 3, 3],
      ['player2', :score, 3, 3]
    ]

    factory :tournament_with_input_completed_two_rounds do
      with_11_players

      finished_count 1
      has_ongoing_round true

      after(:build) do |t|
        bind_scores_of_round(t, round1_scores)
        bind_scores_of_round(t, round2_scores)
      end
    end

    factory :tournament_with_finished_two_rounds do
      with_11_players

      finished_count 2
      has_ongoing_round false

      after(:build) do |t|
        bind_scores_of_round(t, round1_scores)
        bind_scores_of_round(t, round2_scores)
      end

      factory :tournament_with_ongoing_third_rounds do
        has_ongoing_round true

        after(:build) do |t|
          bind_scores_of_round(t, round1_scores)
          bind_scores_of_round(t, round2_scores)
          bind_scores_of_round(t, round3_scores)
        end
      end
    end
  end
end

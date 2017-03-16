FactoryGirl.define do
  factory :tournament do
    trait :with_two_players do
      after(:create) do |t|
        t.players << create(:player, name: 'xxx', tournament: t)
        t.players << create(:player, name: 'yyy', tournament: t)
      end
    end

    trait :with_11_players do
      after(:create) do |t|
        11.times do |i|
          t.players << create(:player, name: "player#{i + 1}", tournament: t)
        end
      end
    end

    factory :tournament_with_finished_two_rounds do
      with_11_players

      finished_count 2

      after(:create) do |t|
        t.rounds << create(:first_finished_round, tournament: t)
        t.rounds << create(:second_finished_round, tournament: t)
      end

      factory :tournament_with_ongoing_third_rounds do
        after(:create) do |t|
          t.rounds << create(:third_ongoing_round, tournament: t)
        end
      end
    end

  end
end

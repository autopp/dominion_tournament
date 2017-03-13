FactoryGirl.define do
  factory :tournament do
    trait :with_two_players do
      after(:create) do |t|
        t.players << create(:player, name: 'xxx', tournament: t)
        t.players << create(:player, name: 'yyy', tournament: t)
      end
    end
  end
end

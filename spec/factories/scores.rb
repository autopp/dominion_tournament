FactoryGirl.define do
  factory :score do
    table
    player

    has_extra_turn false

    trait :with_6tp do
      tp_numerator 6
      tp_denominator 1
    end

    trait :with_4_5tp do
      tp_numerator 9
      tp_denominator 2
    end

    trait :with_3_3tp do
      tp_numerator 10
      tp_denominator 3
    end

    trait :with_3tp do
      tp_numerator 3
      tp_denominator 1
    end

    trait :with_2tp do
      tp_numerator 2
      tp_denominator 1
    end

    trait :with_1tp do
      tp_numerator 1
      tp_denominator 1
    end

    trait :with_0tp do
      tp_numerator 0
      tp_denominator 1
    end

    factory :score_30vp do
      vp_numerator 30
      vp_denominator 1
    end

    factory :score_24vp do
      vp_numerator 24
      vp_denominator 1
    end

    factory :score_21vp do
      vp_numerator 21
      vp_denominator 1
    end

    factory :score_18vp do
      vp_numerator 18
      vp_denominator 1

      factory :score_18vp_with_extra_turn do
        has_extra_turn true
      end
    end

    factory :score_9vp do
      vp_numerator 9
      vp_denominator 1

      factory :score_9vp_with_extra_turn do
        has_extra_turn true
      end
    end
  end
end

FactoryGirl.define do
  factory :score do
    table
    player

    has_extra_turn false

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

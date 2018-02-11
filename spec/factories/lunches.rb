FactoryBot.define do
  factory :lunch do
    channel
    user

    trait :shuffled do
      shuffled_at { Time.current }
    end
  end
end

FactoryBot.define do
  factory :lunch do
    team_id "T0001"
    team_domain "otaku-dev"
    channel_id "C2147483705"
    channel_name "general"
    user

    trait :shuffled do
      shuffled_at { Time.current }
    end
  end
end

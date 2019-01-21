FactoryBot.define do
  factory :lunch do
    channel
    user
    response_url { "http://dummy.url" }

    trait :shuffled do
      shuffled_at { Time.current }
    end
  end
end

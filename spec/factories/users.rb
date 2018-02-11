FactoryBot.define do
  factory :user do
    sequence(:slack_id) { |n| "U%08#{n}" }
    username "otako"
    team
  end
end

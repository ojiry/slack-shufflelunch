FactoryBot.define do
  factory :channel do
    sequence(:slack_id) { |n| "U%08#{n}" }
    name { "general" }
    team
  end
end

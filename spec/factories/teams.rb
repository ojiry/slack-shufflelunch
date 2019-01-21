FactoryBot.define do
  factory :team do
    sequence(:slack_id) { |n| "U%08#{n}" }
    domain { "otaku-dev" }
  end
end

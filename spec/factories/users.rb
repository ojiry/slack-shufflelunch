FactoryBot.define do
  factory :user do
    sequence(:user_id) { |n| "U%08#{n}" }
    user_name "otako"
  end
end

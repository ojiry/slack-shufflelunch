FactoryBot.define do
  factory :user do
    sequence(:user_id) { |n| "W%08#{n}" }
    user_name "MyString"
  end
end

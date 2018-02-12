class Participation < ApplicationRecord
  belongs_to :lunch
  belongs_to :user

  validates :lunch_id, uniqueness: { scope: :user_id }
end

class Group < ApplicationRecord
  belongs_to :lunch

  validates :name, presence: true, uniqueness: { scope: :lunch_id }
end

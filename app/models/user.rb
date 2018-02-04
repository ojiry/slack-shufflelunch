class User < ApplicationRecord
  has_many :group_members
  has_many :groups, through: :group_members, source: :user
  has_many :participations

  validates :user_id, presence: true, uniqueness: true
  validates :user_name, presence: true
end

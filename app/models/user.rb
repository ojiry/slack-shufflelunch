class User < ApplicationRecord
  belongs_to :team

  has_many :group_members
  has_many :groups, through: :group_members, source: :group
  has_many :lunches
  has_many :participations

  validates :slack_id, presence: true, uniqueness: true
  validates :username, presence: true
end

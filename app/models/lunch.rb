class Lunch < ApplicationRecord
  belongs_to :user

  has_many :groups
  has_many :participations
  has_many :users, through: :participations, source: :user

  validates :token, presence: true
  validates :team_id, presence: true
  validates :team_domain, presence: true
  validates :channel_id, presence: true
  validates :channel_name, presence: true
end

class Team < ApplicationRecord
  has_many :channels
  has_many :users

  validates :slack_id, presence: true, uniqueness: true
  validates :domain, presence: true
end

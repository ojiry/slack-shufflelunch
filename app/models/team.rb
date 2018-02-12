class Team < ApplicationRecord
  has_many :channels, dependent: :destroy
  has_many :users, dependent: :destroy

  validates :slack_id, presence: true, uniqueness: true
  validates :domain, presence: true
end

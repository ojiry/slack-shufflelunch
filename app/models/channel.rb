class Channel < ApplicationRecord
  belongs_to :team

  has_many :lunches

  validates :slack_id, presence: true, uniqueness: true
  validates :name, presence: true
end

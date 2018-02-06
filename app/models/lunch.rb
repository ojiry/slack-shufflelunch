class Lunch < ApplicationRecord
  belongs_to :user

  has_many :groups
  has_many :participations
  has_many :users, through: :participations, source: :user

  validates :team_id, presence: true
  validates :team_domain, presence: true
  validates :channel_id, presence: true
  validates :channel_name, presence: true

  def previous_lunch
    @previous_lunch ||= self.class
      .where(team_id: team_id, channel_id: channel_id)
      .where.not(shuffled_at: nil)
      .where('created_at < ?', created_at)
      .order(created_at: :desc).first
  end
end

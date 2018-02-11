class Lunch < ApplicationRecord
  belongs_to :channel
  belongs_to :user

  has_many :groups
  has_many :participations
  has_many :users, through: :participations, source: :user

  scope :shuffled, -> { where.not(shuffled_at: nil) }

  def participant_ids_text
    users.map { |user| "<@#{user.user_id}>" }.join(', ')
  end

  def previous_lunch
    @previous_lunch ||= self.class.shuffled
      .where(channel_id: channel_id)
      .where('created_at < ?', created_at)
      .order(created_at: :desc).first
  end

  def shuffled?
    !!shuffled_at
  end
end

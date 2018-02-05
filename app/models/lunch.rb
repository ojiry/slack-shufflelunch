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

  def shuffle
    ActiveRecord::Base.transaction do
      member_count = participations.count
      group_count = member_count < 4 ? 1 : member_count / 4
      arr = []
      1.upto group_count do |i|
        arr << groups.create!(name: "Group#{i}")
      end
      # if previous_lunch
      #   # noop
      # else
        users.shuffle.each_slice(group_count).with_index do |slice, index|
          slice.each do |user|
            arr[index].group_members.create!(user: user)
          end
        end
      # end
      update!(shuffled_at: Time.current)
    end
    return shuffled_at.present?
  end
end

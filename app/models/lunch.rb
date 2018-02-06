class Lunch < ApplicationRecord
  belongs_to :user

  has_many :groups
  has_many :participations
  has_many :users, through: :participations, source: :user

  validates :team_id, presence: true
  validates :team_domain, presence: true
  validates :channel_id, presence: true
  validates :channel_name, presence: true

  def json_result
    text = ""
    groups.each do |group|
      text << "#{group.name}: #{group.users.map { |u| "<@#{u.user_id}>" }.join(', ')}\n"
    end
    {
      "text": text,
      "response_type": "in_channel",
    }.to_json
  end

  def previous_lunch
    @previous_lunch ||= self.class
      .where(team_id: team_id, channel_id: channel_id)
      .where.not(shuffled_at: nil)
      .where('created_at < ?', created_at)
      .order(created_at: :desc).first
  end

  def shuffle
    member_count = participations.count
    return false if member_count.zero?
    divresult = member_count.divmod(4)
    group_count, slice_count =
      if divresult.first.zero?
        [1, 4]
      else
        divresult.last.zero? ? [divresult.first, 4] : [divresult.first, 5]
      end
    arr = []
    ActiveRecord::Base.transaction do
      1.upto(group_count) { |i| arr << groups.create!(name: "Group#{i}") }
      # if previous_lunch
      #   # noop
      # else
        users.shuffle.each_slice(slice_count).with_index do |slice, index|
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

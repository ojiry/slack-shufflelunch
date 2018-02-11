class Group < ApplicationRecord
  belongs_to :lunch

  has_many :group_members
  has_many :users, through: :group_members, source: :user

  validates :name, presence: true, uniqueness: { scope: :lunch_id }

  def text
    "#{name}: #{users.map { |user| "<@#{user.slack_id}>" }.join(', ')}"
  end
end

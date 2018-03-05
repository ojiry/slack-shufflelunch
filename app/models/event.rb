class Event < ApplicationRecord
  validates :slack_id, presence: true, uniqueness: true
end

require 'rails_helper'

RSpec.describe Lunch, type: :model do
  describe '#previous_lunch' do
    let(:team) { create :team }
    let(:channel) { create :channel, team: team }
    let(:lunch) { create :lunch, channel: channel, created_at: 1.day.ago }

    let!(:previous_lunch) { create :lunch, :shuffled, channel: channel, created_at: 3.days.ago }

    subject { lunch.previous_lunch }

    before do
      create :lunch, :shuffled, channel: channel, created_at: 4.days.ago
      create :lunch, :shuffled, created_at: 2.days.ago
      create :lunch, channel: channel, created_at: 2.days.ago
    end

    it { is_expected.to eq previous_lunch }
  end
end

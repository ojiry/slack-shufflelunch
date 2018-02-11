require 'rails_helper'

RSpec.describe Lunch, type: :model do
  describe '#previous_lunch' do
    # let(:lunch) { create :lunch, team_id: 'T12345', channel_id: 'C1H9RESGL', created_at: 1.day.ago }

    # let!(:previous_lunch) { create :lunch, :shuffled, team_id: 'T12345', channel_id: 'C1H9RESGL', created_at: 3.days.ago }

    # subject { lunch.previous_lunch }

    # before do
    #   create :lunch, :shuffled, team_id: 'T12345', channel_id: 'C1H9RESGL', created_at: 4.days.ago
    #   create :lunch, :shuffled, team_id: 'T34567', channel_id: 'C1H9RESGL', created_at: 2.days.ago
    #   create :lunch, :shuffled, team_id: 'T12345', channel_id: 'C1I7SEIGB', created_at: 2.days.ago
    #   create :lunch, team_id: 'T12345', channel_id: 'C1H9RESGL', created_at: 2.days.ago
    # end

    # it { is_expected.to eq previous_lunch }
  end
end

require 'rails_helper'

RSpec.describe LunchShuffler, type: :model do
  let(:lunch) { create :lunch }
  let(:lunch_shuffler) { LunchShuffler.new(lunch) }

  describe '#shuffle!' do
    before do
      create_list :participation, 10, lunch: lunch
    end

    it { expect(lunch_shuffler.shuffle!).to be true }

    it { expect { lunch_shuffler.shuffle! }.to change { [Group.count, GroupMember.count] }.from([0, 0]).to([2, 10]) }

    context 'when lunch has #previous_lunch' do
      let(:previous_lunch) { create :lunch, :shuffled, channel_id: lunch.channel_id, created_at: lunch.created_at.days_ago(1) }

      before do
        create_list :participation, 6, lunch: previous_lunch
        LunchShuffler.new(previous_lunch).shuffle!
      end

      it { expect(lunch_shuffler.shuffle!).to be true }

      it { expect { lunch_shuffler.shuffle! }.to change { [Group.count, GroupMember.count] }.from([2, 6]).to([4, 16]) }
    end
  end

  describe '#group_count' do
    subject { lunch_shuffler.send(:group_count) }

    [
      [1, 1],  [2, 1],  [3, 1],
      [4, 1],  [5, 1],  [6, 2],
      [7, 2],  [8, 2],  [9, 2],
      [10, 2], [11, 3], [12, 3],
      [13, 3], [14, 3], [15, 4],
      [16, 4], [17, 4], [18, 4],
      [19, 5], [20, 5], [21, 5],
    ].each do |member_count, group_count|
      context "when member_count is #{member_count}" do
        before do
          allow(lunch_shuffler).to receive(:member_count) { member_count}
        end

        it { is_expected.to eq group_count }
      end
    end
  end
end

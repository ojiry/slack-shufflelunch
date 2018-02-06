require 'rails_helper'

RSpec.describe GroupBuilder, type: :model do
  let(:lunch) { create :lunch }
  let(:group_builder) { GroupBuilder.new(lunch) }

  describe '#build!' do
    before do
      10.times { |i| create :participation, lunch: lunch }
    end

    it { expect(group_builder.build!).to be true }

    it { expect { group_builder.build! }.to change { [Group.count, GroupMember.count] }.from([0, 0]).to([3, 10]) }
  end

  describe '#group_count' do
    subject { group_builder.send(:group_count) }

    [
      [1, 1],  [2, 1],  [3, 1],
      [4, 1],  [5, 1],  [6, 2],
      [7, 2],  [8, 2],  [9, 3],
      [10, 3], [11, 3], [12, 3],
      [13, 3], [14, 3], [15, 4],
      [16, 4], [17, 4], [18, 4],
      [19, 5], [20, 5], [21, 5],
    ].each do |member_count, group_count|
      context "when member_count is #{member_count}" do
        before do
          allow(group_builder).to receive(:member_count) { member_count}
        end

        it { is_expected.to eq group_count }
      end
    end
  end
end

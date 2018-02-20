require 'rails_helper'

RSpec.describe Group, type: :model do
  describe "#text" do
    subject { group.text }

    let(:group) { create :group, name: "Group 1" }

    it { is_expected.to eq "Group 1: " }
  end
end

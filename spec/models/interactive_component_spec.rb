require 'rails_helper'

RSpec.describe InteractiveComponent, type: :model do
  let(:user) { create :user }
  let(:lunch) { create :lunch }
  let(:interactive_component) { InteractiveComponent.new(lunch) }

  describe "#actions" do
    subject { interactive_component.send(:actions) }

    context "when a participant is zero" do
      let(:expected) {
        [
          { name: "join", text: "Join", style: "primary", type: "button", value: "join" },
          { name: "leave", text: "Leave", style: "danger", type: "button", value: "leave" }
        ]
      }

      it { is_expected.to eq expected }
    end

    context "when a participant exsists" do
      let(:expected) {
        [
          { name: "join", text: "Join", style: "primary", type: "button", value: "join" },
          { name: "leave", text: "Leave", style: "danger", type: "button", value: "leave" },
          {
            name: "shuffle", text: "Shuffle", type: "button", value: "shuffle", confirm: {
              title: "Are you sure?",
              text: "If you put Shuffle button, other members will be not able to entry lunch, right?",
              ok_text: "Yes", dismiss_text: "No"
            }
          }
        ]
      }

      before do
        create :participation, lunch: lunch, user: user
      end

      it { is_expected.to eq expected }
    end

    context "when lunch had shuffled" do
      let(:expected) { [ { name: "leave", text: "Leave", style: "danger", type: "button", value: "leave" } ] }

      before do
        create :participation, lunch: lunch, user: user
        GroupBuilder.new(lunch).build!
      end

      it { is_expected.to eq expected }
    end
  end

  describe "#attachments" do
    subject { interactive_component.send(:attachments) }
  end

  describe "#text" do
    subject { interactive_component.send(:text) }

    before do
      create :participation, lunch: lunch, user: user
    end

    context "when lunch has not shuffled" do
      it { is_expected.to eq "Would you like to join the Shuffle Lunch today? <@#{user.slack_id}>"}
    end

    context "when lunch had shuffled" do
      before do
        GroupBuilder.new(lunch).build!
      end

      it { is_expected.to eq "Shuffle lunch group of today\n1group: <@#{user.slack_id}>" }
    end
  end

  describe "#response_type" do
    subject { interactive_component.send(:response_type) }

    it { is_expected.to eq "in_channel" }
  end
end

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
      let(:expected) {
        [
          { name: "leave", text: "Leave", style: "danger", type: "button", value: "leave" },
          {
            name: "reshuffle", text: "Reshuffle", type: "button", value: "reshuffle", confirm: {
              title: "Are you sure?",
              text: "If you put Reshuffle button, groups will change, right?",
              ok_text: "Yes", dismiss_text: "No"
            }
          },
          { name: "bye", text: "Bye", type: "button", value: "bye" }
        ]
      }

      before do
        create :participation, lunch: lunch, user: user
        GroupBuilder.new(lunch).build!
      end

      it { is_expected.to eq expected }
    end
  end

  describe "#attachments" do
    subject { interactive_component.send(:attachments) }

    let(:expected) {
      [
        text: text,
        fallback: "Your current Slack client doesn’t support Shuffle Lunch",
        callback_id: lunch.id,
        color: "#3AA3E3",
        attachment_type: "default",
        actions: interactive_component.send(:actions)
      ]
    }

    context "when lunch has not shuffled" do
      let(:text) { "Please put join or leave button" }

      it { is_expected.to eq expected }
    end

    context "when lunch had shuffled" do
      let(:text) { "If you can't join Shuffle lunch, please put leave button" }

      before do
        GroupBuilder.new(lunch).build!
      end

      it { is_expected.to eq expected }
    end
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

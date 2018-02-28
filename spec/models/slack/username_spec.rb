require 'rails_helper'

RSpec.describe Slack::Username, type: :model do
  let(:slack_user) { Slack::Username.new(username_text) }

  describe "#slack_id" do
    subject { slack_user.slack_id }

    context "when username_text is <@U1234>" do
      let(:username_text) { "<@U1234>" }

      it { is_expected.to eq "U1234" }
    end

    context "when username_text is <@U1234|otako>" do
      let(:username_text) { "<@U1234|otako>" }

      it { is_expected.to eq "U1234" }
    end

    context "when username_text is @otako" do
      let(:username_text) { "@otako" }

      context "when a user that name is otako exists" do
        let(:slack_id) { "U2345" }

        before { create :user, slack_id: slack_id, username: "otako" }

        it { is_expected.to eq "U2345" }
      end

      context "when a user that name is otako does not exist" do
        before do
          # allow_any_instance_of(Slack::Web::Client).to receive(:user_info)
          subject.call
        end

        # it { expect_any_instance_of(Slack::Web::Client).to receive(:user_info) }
      end
    end

    context "when username_text is otako" do
      let(:username_text) { "otako" }

      context "when a user that name is otako exists" do
        let(:slack_id) { "U2345" }

        before { create :user, slack_id: slack_id, username: "otako" }

        it { is_expected.to eq "U2345" }
      end

      context "when a user that name is otako does not exist" do
        before do
          # allow_any_instance_of(Slack::Web::Client).to receive(:user_info)
          subject.call
        end

        # it { expect_any_instance_of(Slack::Web::Client).to receive(:user_info) }
      end
    end

    context "when username_text invalid" do
      # TODO
    end
  end

  describe "#username" do
    subject { slack_user.username }

    let(:slack_id) { "U2345" }
    let(:username) { "otako" }

    before { create :user, slack_id: slack_id, username: username }

    context "when username_text is <@U2345>" do
      let(:username_text) { "<@U2345>" }

      it { is_expected.to eq username }
    end

    context "when username_text is <@U2345|otako>" do
      let(:username_text) { "<@U2345|otako>" }

      it { is_expected.to eq username }
    end

    context "when username_text is @otako" do
      let(:username_text) { "@otako" }

      context "when a user that name is otako exists" do
        it { is_expected.to eq username }
      end

      context "when a user that name is otako does not exist" do
        before do
          # allow_any_instance_of(Slack::Web::Client).to receive(:user_info)
          subject.call
        end

        # it { expect_any_instance_of(Slack::Web::Client).to receive(:user_info) }
      end
    end

    context "when username_text is otako" do
      let(:username_text) { "otako" }

      context "when a user that name is otako exists" do
        it { is_expected.to eq username }
      end
    end

    context "when username_text invalid" do
      # TODO
    end
  end
end

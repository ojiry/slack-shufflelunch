require 'rails_helper'

RSpec.describe Slack::Bot, type: :model do
  describe '#reply' do
    subject { -> { slack_bot.reply } }

    let(:team) { create :team }
    let(:channel) { create :channel, team: team }
    let(:user) { create :user, username: 'lovelunch', team: team }
    let(:bot_user) { create :user, username: 'otako', team: team }
    let(:params) {
      {
        team_id: team.slack_id,
        event: {
          channel: channel.slack_id,
          user: user.slack_id,
          text: "<@#{bot_user.slack_id}> Please create shuffle lunch"
        }
      }.with_indifferent_access
    }
    let(:slack_bot) { Slack::Bot.new(Slack::Parameter.new(params)) }

    before do
      allow(Rails.configuration.x.slack).to receive(:bot_username) { bot_user.username }
      allow(slack_bot).to receive(:post_message)
    end

    it { is_expected.to change { Lunch.count }.by(1) }

    context "" do
      before do
        subject.call
      end

      it { expect(slack_bot).to have_received(:post_message).once }
    end
  end
end

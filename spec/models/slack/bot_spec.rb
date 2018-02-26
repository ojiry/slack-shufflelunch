require 'rails_helper'

RSpec.describe Slack::Bot, type: :model do
  describe '#reply' do
    subject { -> { slack_bot.reply } }

    let(:bot_user) { create :user }
    let(:params) {
      {
        team_id: 'T001',
        event: {
          channel: 'C001',
          user: 'U001',
          text: "<@#{bot_user.slack_id}> Please create shuffle lunch"
        }
      }.with_indifferent_access
    }
    let(:slack_bot) { Slack::Bot.new(bot_user.username, params) }

    before do
      allow(slack_bot).to receive(:post_message)
    end

    it { is_expected.to change { Lunch.count }.by(1) }
  end
end

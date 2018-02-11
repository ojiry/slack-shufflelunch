require 'rails_helper'

RSpec.describe Slack::SlashCommandsController, type: :controller do
  describe 'POST create' do
    subject { response }

    let(:token) { 'valid_token' }
    let(:params) {
      {
        token: token,
        team_id: "XXXXXXXXXXXX",
        team_domain: "muddydixon",
        channel_id: "XXXXXXXXXXX",
        channel_name: "general",
        user_id: "XXXXXXXXXXXX",
        user_name: "muddydixon",
        command: "/shufflelunch",
        text: "",
        response_url: "https://hooks.slack.com/commands/XXXXXXXXX/XXXXXXX/XXXXXXXXXXX"
      }
    }

    before do
      allow(Rails.configuration.x.slack).to receive(:verification_token) { 'valid_token' }
      post :create, params: params
    end

    it { is_expected.to have_http_status(:ok) }

    context 'when unauthorized token' do

      let(:token) { 'invalid_token' }

      it { is_expected.to have_http_status(:forbidden) }
    end
  end
end

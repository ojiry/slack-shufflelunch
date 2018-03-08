require "rails_helper"

RSpec.describe "POST /slack/event_subscriptions", type: :request do
  let(:token) { "gIkuvaNzQIHg97ATvDxqgjtO" }
  let(:bot) { create :user, username: "otako" }
  let(:params) {
    {
      token: token,
      event: {
        text: ""
      }
    }
  }

  before do
    allow(Rails.configuration.x.slack).to receive(:verification_token) { 'gIkuvaNzQIHg97ATvDxqgjtO' }
    allow(Rails.configuration.x.slack).to receive(:bot_username) { bot.username }
    post "/slack/event_subscriptions", params: params
  end

  it { expect(response).to have_http_status :ok }

  context 'when unauthorized token' do
    let(:token) { 'invalid_token' }

    it { expect(response).to have_http_status(:forbidden) }
  end
end

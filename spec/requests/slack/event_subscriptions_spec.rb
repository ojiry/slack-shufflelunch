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

    it { expect(response).to have_http_status :forbidden }
  end

  context "when type parameter is url_verification" do
    let(:challenge) { "wWYpKluHySvOBgPZB9TEdKNoYVs5TKGoabJl2MH6JuHLUG8nL4mN" }
    let(:params) {
      {
        token: token,
        challenge: challenge,
        type: "url_verification",
        event_subscription: {
          token: token,
          challenge: challenge,
          type: "url_verification",
        }
      }
    }

    it { expect(response).to have_http_status :ok }
    it { expect(JSON.parse(response.body)["challenge"]).to eq challenge }
  end
end

require "rails_helper"

RSpec.describe "POST /slack/slash_commands", type: :request do
  let(:token) { "gIkuvaNzQIHg97ATvDxqgjtO" }
  let(:params) {
    {
      token: token,
      team_id: "T0001",
      team_domain: "example",
      enterprise_id: "E0001",
      enterprise_name: "Globular%20Construct%20Inc",
      channel_id: "C2147483705",
      channel_name: "test",
      user_id: "U2147483697",
      user_name: "Steve",
      command: "/shufflelunch",
      text: "<@U2329123697|otako>",
      response_url: "https://hooks.slack.com/commands/1234/5678",
      trigger_id: "13345224609.738474920.8088930838d88f008e0"
    }
  }

  before do
    allow(Rails.configuration.x.slack).to receive(:verification_token) { 'gIkuvaNzQIHg97ATvDxqgjtO' }
    post "/slack/slash_commands", params: params
  end

  it { expect(response).to have_http_status :ok }

  it 'returns interactive components json' do
    expect(response.body).to eq Slack::InteractiveMessage.new(Lunch.last).as_json.to_json
  end

  context 'when unauthorized token' do
    let(:token) { 'invalid_token' }

    it { expect(response).to have_http_status(:forbidden) }
  end
end

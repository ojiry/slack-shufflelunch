require "rails_helper"

RSpec.describe "POST /slack/interactive_components", type: :request do
  let(:token) { "gIkuvaNzQIHg97ATvDxqgjtO" }
  let(:lunch) { create :lunch }
  let(:channel) { lunch.channel }
  let(:team) { channel.team }
  let(:params) {
    {
      payload: {
        actions: [ { name: "join", type: "button", value: "join" } ],
        callback_id: lunch.id,
        team: { id: team.slack_id, domain: team.domain },
        channel: { id: channel.slack_id, name: channel.name },
        user: { id: "U2147483697", name: "Steve" },
        action_ts: "1499824071.755716",
        message_ts: "1499824068.033282",
        attachment_id: "1",
        token: token,
        is_app_unfurl: false,
        original_message: {
          text: "Would you like to join the Shuffle Lunch today?",
          bot_id: "XXXXXXXXX",
          attachments: [
            {
              callback_id: lunch.id,
              fallback: "choose version",
              id: 1,
              actions: [ { name: "action", text: "Join", style: "primary", type: "button", value: "join" } ]
            }
          ],
          type: "message",
          subtype: "bot_message",
          ts: "1499824068.033282"
        },
        response_url: "https://hooks.slack.com/commands/1234/5678"
      }.to_json
    }
  }

  before do
    allow(Rails.configuration.x.slack).to receive(:verification_token) { 'gIkuvaNzQIHg97ATvDxqgjtO' }
    post "/slack/interactive_components", params: params
  end

  it { expect(response).to have_http_status :ok }

  it 'returns interactive components json' do
    expect(response.body).to eq Slack::InteractiveComponent.new(lunch.reload).as_json.to_json
  end

  context 'when unauthorized token' do
    let(:token) { 'invalid_token' }

    it { expect(response).to have_http_status(:forbidden) }
  end
end

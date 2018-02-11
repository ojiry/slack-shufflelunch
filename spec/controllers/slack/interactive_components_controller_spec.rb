require 'rails_helper'

RSpec.describe Slack::InteractiveComponentsController, type: :controller do
  describe 'POST create' do
    subject { response }

    let(:lunch) { create :lunch }
    let(:token) { 'valid_token' }
    let(:params) {
      {
        payload: {
          actions: [
            {
              name: "join",
              type: "button",
              value: "join"
            }
          ],
          callback_id: lunch.id,
          team: {
            id: "XXXXXXX",
            domain: "muddydixon"
          },
          channel: {
            id: "XXXXXXXXX",
            name: "general"
          },
          user: {
            id: "XXXXXXXXX",
            name: "muddydixon"
          },
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
                actions: [
                  {
                    name: "action",
                    text: "Join",
                    style: "primary",
                    type: "button",
                    value: "join"
                  }
                ]
              }
            ],
            type: "message",
            subtype: "bot_message",
            ts: "1499824068.033282"
          },
          response_url: "https: //hooks.slack.com/actions/XXXXXXXXXXXX/XXXXXXXXXXXXXXX/XXXXXXXXXXXXXXX"
        }.to_json
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

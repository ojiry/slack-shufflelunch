require 'rails_helper'

RSpec.describe Slack::EventSubscriptionsController, type: :controller do
  describe 'POST create' do
    # subject { response }

    # let(:bot) { create :user }
    # let(:token) { 'valid_token' }
    # let(:params) {
    #   {
    #     token: token,
    #     event: {
    #       text: ""
    #     }
    #   }
    # }

    # before do
    #   allow(Rails.configuration.x.slack).to receive(:verification_token) { 'valid_token' }
    #   allow(Rails.configuration.x.slack).to receive(:bot_username) { bot.user_name }
    #   post :create, params: params
    # end

    # it { is_expected.to have_http_status(:ok) }

    # context 'when unauthorized token' do

    #   let(:token) { 'invalid_token' }

    #   it { is_expected.to have_http_status(:forbidden) }
    # end
  end
end

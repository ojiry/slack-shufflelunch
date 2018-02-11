class ApplicationController < ActionController::API
  before_action :verify_slack_token

  private

    def payload_params
      JSON.parse(params[:payload].presence || {}).with_indifferent_access
    end

    def slack_bot_username
      Rails.configuration.x.slack.bot_username
    end

    def slack_verification_token
      Rails.configuration.x.slack.verification_token
    end

    def verify_slack_token
      token = params[:token].presence || payload_params[:token]
      if token != slack_verification_token
        head :forbidden
      end
    end
end

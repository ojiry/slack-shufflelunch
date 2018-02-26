class ApplicationController < ActionController::API
  before_action :verify_slack_token

  private

    def slack_parameter
      @slack_parameter ||= Slack::Parameter.parse(params)
    end

    def slack_verification_token
      Rails.configuration.x.slack.verification_token
    end

    def verify_slack_token
      if slack_parameter.token != slack_verification_token
        head :forbidden
      end
    end
end

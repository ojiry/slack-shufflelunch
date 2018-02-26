class Slack::EventSubscriptionsController < ApplicationController
  before_action :verify_challenge

  def create
    if slack_parameter.event_type == 'message'
      Slack::Bot.new(slack_parameter).reply
    end
    head :ok
  end

  private

    def verify_challenge
      if slack_parameter.type == 'url_verification'
        render json: { challenge: slack_parameter.challenge }
      end
    end
end

class Slack::EventSubscriptionsController < ApplicationController
  before_action :verify_challenge

  def create
    event_subscription = Slack::EventSubscription.new(slack_parameter)
    event_subscription.create!
    render json: event_subscription.as_json
  end

  private
    def verify_challenge
      if slack_parameter.type == 'url_verification'
        render json: { challenge: slack_parameter.challenge }
      end
    end
end

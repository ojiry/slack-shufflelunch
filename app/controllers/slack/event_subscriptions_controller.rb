class Slack::EventSubscriptionsController < ApplicationController
  before_action :verify_challenge

  def create
    if app_mention? && new_event?
      event = Event.new(slack_id: slack_parameter.event_id)
      Slack::Bot.new(slack_parameter).reply if event.save
    end
    head :ok
  end

  private

    def app_mention?
      slack_parameter.event_type == 'app_mention'
    end

    def new_event?
      !Event.exists?(slack_id: slack_parameter.event_id)
    end

    def verify_challenge
      if slack_parameter.type == 'url_verification'
        render json: { challenge: slack_parameter.challenge }
      end
    end
end

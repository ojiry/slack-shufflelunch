class Slack::EventSubscriptionsController < ApplicationController
  before_action :verify_challenge

  def create
    if params[:event][:type] == 'message'
      bot = SlackBot.new(slack_bot_username, params)
      bot.reply
    end
    head :ok
  end

  private

    def verify_challenge
      if params[:type] == 'url_verification'
        render json: { challenge: params[:challenge] }
      end
    end
end

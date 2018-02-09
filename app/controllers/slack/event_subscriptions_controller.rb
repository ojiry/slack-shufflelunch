class Slack::EventSubscriptionsController < ApplicationController
  before_action :valid_slack_token, :valid_challenge, :valid_text

  def create
    Slack::Web::Client.new.chat_postMessage(channel: params[:event]['channel'], text: 'Hi!')
    head :ok
  end

  private

  def valid_text
    unless /\A<@#{User.find_by(user_name: Rails.configuration.x.slack.bot_username).user_id}>/.match?(params[:event][:text])
      head :ok
    end
  end

  def valid_challenge
    if params[:type] == 'url_verification'
      render json: { challenge: params[:challenge] }
    end
  end

  def valid_slack_token
    if params[:token] != Rails.configuration.x.slack.verification_token
      head :forbidden
    end
  end
end

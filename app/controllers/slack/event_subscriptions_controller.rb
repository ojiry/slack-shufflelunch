class Slack::EventSubscriptionsController < ApplicationController
  before_action :valid_challenge, :valid_text

  def create
    # Slack::Web::Client.new.chat_postMessage(channel: params[:event]['channel'], text: 'Hi!')
    head :ok
  end

  private

  def valid_text
    unless /\A<@#{User.find_by(username: Rails.configuration.x.slack.bot_username).slack_id}>/.match?(params[:event][:text])
      head :ok
    end
  end

  def valid_challenge
    if params[:type] == 'url_verification'
      render json: { challenge: params[:challenge] }
    end
  end
end

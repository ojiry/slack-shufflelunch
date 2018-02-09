class Slack::EventSubscriptionsController < ApplicationController
  before_action :valid_slack_token
  before_action :valid_challenge

  def create
    render json: { } # TODO
  end

  private

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

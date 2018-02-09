class Slack::SlashCommandsController < ApplicationController
  before_action :valid_slack_token

  def create
    lunch_builder = LunchBuilder.new(params)
    lunch = lunch_builder.build!
    render json: InteractiveComponentBuilder.new(lunch).build
  end

  private

  def valid_slack_token
    if params[:token] != Rails.configuration.x.slack.verification_token
      head :forbidden
    end
  end
end

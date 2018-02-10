class Slack::SlashCommandsController < ApplicationController
  def create
    lunch_builder = LunchBuilder.new(params)
    lunch = lunch_builder.build!
    render json: InteractiveComponentBuilder.new(lunch).build
  end
end

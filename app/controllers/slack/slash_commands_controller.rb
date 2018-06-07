class Slack::SlashCommandsController < ApplicationController
  def create
    slash_command = Slack::SlashCommand.new(slack_parameter)
    slash_command.create!
    render json: slash_command.as_json
  end
end

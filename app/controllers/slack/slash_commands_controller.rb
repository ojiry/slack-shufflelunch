class Slack::SlashCommandsController < ApplicationController
  def create
    logger.info params.inspect
    render json: json
  end

  private

  def json
    {
      "text": "Would you like to join the Suffle Lunch today?",
      "attachments": [
        {
          "text": "Choose a game to play",
          "fallback": "You are unable to choose a game",
          "callback_id": "wopr_game",
          "color": "#3AA3E3",
          "attachment_type": "default",
          "actions": [
            {
              "name": "action",
              "text": "Join",
              "style": "primary",
              "type": "button",
              "value": "join"
            },
            {
              "name": "action",
              "text": "Leave",
              "style": "danger",
              "type": "button",
              "value": "leave"
            },
            {
              "name": "action",
              "text": "Finish",
              "type": "button",
              "value": "finish"
            }
          ]
        }
      ]
    }.to_json
  end
end

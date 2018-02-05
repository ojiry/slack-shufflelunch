class Slack::SlashCommandsController < ApplicationController
  def create
    user = User.find_or_create_by(user_id: params[:user_id]) do |u|
      u.user_name = params[:user_name]
    end
    @lunch = user.lunches.create(lunch_params)
    render json: json
  end

  private

  def lunch_params
    params.permit(:token, :team_id, :team_domain, :channel_id, :channel_name)
  end

  def json
    {
      "text": "Would you like to join the Shuffle Lunch today?",
      "attachments": [
        {
          "text": "Choose a game to play",
          "fallback": "You are unable to choose a game",
          "callback_id": @lunch.id,
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
              "text": "Shuffle",
              "type": "button",
              "value": "shuffle"
            }
          ]
        }
      ]
    }.to_json
  end
end

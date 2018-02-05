class Slack::InteractiveComponentsController < ApplicationController
  def create
    @lunch = Lunch.find(payload_params[:callback_id])
    user = User.find_or_create_by(user_id: user_params[:id]) do |u|
      u.user_name = user_params[:name]
    end
    case payload_params[:actions].first[:value]
    when 'join'
      if @lunch.participations.none? { |p| p.user_id == user.id }
        @lunch.participations.create(user: user)
      end
    when 'leave'
      @lunch.participations.where(user_id: user.id).destroy_all
    when 'suffle'
      @lunch.suffle
      render json: suffle_json and return
    end
    render json: json
  end

  private

  def user_params
    payload_params[:user]
  end

  def payload_params
    JSON.parse(params[:payload]).with_indifferent_access
  end

  def suffle_json
    {
      "text": "Finish"
    }.to_json
  end

  def json
    {
      "text": "Would you like to join the Suffle Lunch today? #{@lunch.users.map(&:user_name).join(',')}",
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
              "text": "Suffle",
              "type": "button",
              "value": "suffle"
            }
          ]
        }
      ]
    }.to_json
  end
end

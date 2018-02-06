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
    when 'shuffle'
      if @lunch.shuffle
        render json: @lunch.json_result and return
      else
        render json: json
      end
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

  def json
    {
      "text": "Would you like to join the Shuffle Lunch today? #{@lunch.users.map { |u| "<@#{u.user_id}>" }.join(', ')}",
      "response_type": "in_channel",
      "attachments": [
        {
          "text": "Please put join or leave button",
          "fallback": "Your current Slack client doesn’t support Shuffle Lunch",
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
              "value": "shuffle",
              "confirm": {
                "title": "Are you sure?",
                "text": "If you put Shuffle button, other members will be not able to entry lunch, right?",
                "ok_text": "Yes",
                "dismiss_text": "No"
              }
            }
          ]
        }
      ]
    }.to_json
  end
end

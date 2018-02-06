class LunchBuilder
  def initialize(params)
    @params = params
  end

  def build!
    ActiveRecord::Base.transaction do
      user = User.find_or_create_by!(user_id: params[:user_id]) do |u|
        u.user_name = params[:user_name]
      end
      @lunch = user.lunches.create! do |l|
        l.team_id      = params[:team_id]
        l.team_domain  = params[:team_domain]
        l.channel_id   = params[:channel_id]
        l.channel_name = params[:channel_name]
      end
    end
    true
  end

  def to_json
    {
      "text": "Would you like to join the Shuffle Lunch today?",
      "response_type": "in_channel",
      "attachments": [
        {
          "text": "Please put join or leave button",
          "fallback": "Your current Slack client doesn’t support Shuffle Lunch",
          "callback_id": lunch&.id,
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

  private

  attr_reader :lunch, :params
end

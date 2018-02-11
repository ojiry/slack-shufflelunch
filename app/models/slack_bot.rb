class SlackBot
  def initialize(username, params)
    @user = User.find_by(username: username)
    @params = params
  end

  def reply
    return unless mention?
    Slack::Web::Client.new.chat_postMessage(channel: params[:event]['channel'], attachments: test_message.to_json, as_user: true)
  end

  private

  attr_reader :params, :user

  def mention?
    /\A<@#{user.slack_id}>/.match?(params[:event][:text])
  end

  def test_message
    {
      "text": "I am a test message http://slack.com",
      "attachments": [
        {
          "text": "Please put join or leave button",
          "fallback": "Your current Slack client doesn’t support Shuffle Lunch",
          "callback_id": 1,
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

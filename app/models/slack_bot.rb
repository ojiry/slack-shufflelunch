class SlackBot
  def initialize(bot_username, params)
    @bot = User.find_by!(username: bot_username)
    @params = params
  end

  def reply
    if lunch_request?
      team = Team.find_or_create_by!(slack_id: params[:team_id]) do |t|
        t.domain = 'todo'
      end
      channel = team.channels.find_or_create_by!(slack_id: params[:event][:channel]) do |c|
        c.name = 'todo'
      end
      user = User.find_or_create_by!(slack_id: params[:event][:user]) do |u|
        u.username = 'todo'
        u.team = team
      end
      lunch = user.lunches.find_or_create_by!(channel_id: channel.id, shuffled_at: nil)
      post_message(lunch)
    end
  end

  def post_message(lunch)
    Slack::Web::Client.new.chat_postMessage(
      channel: params[:event]['channel'],
      text: 'Would you like to join the Shuffle Lunch today?',
      attachments: test_message(lunch)
    )
  end

  private

  attr_reader :params, :bot

  def lunch_request?
    !!match_data
  end

  def with_users
    match_data[1] ? match_data[2] : []
  end

  def match_data
    /\A<@#{bot.slack_id}> please create shuffle lunch(.*)/i.match(params[:event][:text])
  end

  def test_message(lunch)
    [
      {
        "text": "Please put join or leave button",
        "fallback": "Your current Slack client doesn’t support Shuffle Lunch",
        "callback_id": lunch.id,
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
  end
end

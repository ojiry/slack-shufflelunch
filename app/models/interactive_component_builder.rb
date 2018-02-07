class InteractiveComponentBuilder
  def initialize(lunch)
    @lunch = lunch
  end

  def build
    if lunch.shuffled?
      {
        "text": "Shuffle lunch group of today\n#{lunch.groups.map(&:text).join("\n")}",
        "response_type": "in_channel",
      }
    else
      {
        "text": "Would you like to join the Shuffle Lunch today? #{lunch&.participant_ids_text}",
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
      }
    end
  end

  private

  attr_reader :lunch
end

module Slack
  class InteractiveComponent
    class Button
      def initialize(text, style: nil, confirm: nil)
        @name    = text.downcase
        @text    = text
        @style   = style
        @type    = 'button'
        @value   = text.downcase
        @confirm = confirm
      end

      def as_json
        {
          name: name,
          text: text,
          style: style,
          type: type,
          value: value,
          confirm: confirm
        }.compact
      end

      private

      attr_reader :name, :text, :style, :type, :value, :confirm
    end

    def initialize(lunch)
      @lunch = lunch
    end

    def as_json
      {
        text: text,
        response_type: response_type,
        attachments: attachments
      }
    end

    private

    attr_reader :lunch

    def actions
      buttons = []
      buttons << Button.new("Join", style: "primary") unless lunch.shuffled?
      buttons << Button.new("Leave", style: "danger")
      if lunch.users.exists?
        button_text, confirm_text =
          if lunch.shuffled?
            ["Reshuffle", "If you put Reshuffle button, groups will change, right?"]
          else
            ["Shuffle", "If you put Shuffle button, other members will be not able to entry lunch, right?"]
          end
        confirm = { title: "Are you sure?", text: confirm_text, ok_text: "Yes", dismiss_text: "No" }
        buttons << Button.new(button_text, confirm: confirm)
      end
      if lunch.shuffled?
        confirm = { title: "Are you sure?", text: "The result will be invisible, but is it good?", ok_text: "Yes", dismiss_text: "No" }
        buttons << Button.new("Bye", confirm: confirm)
      end
      buttons.map(&:as_json)
    end

    def attachments
      attachments_text =
        if lunch.shuffled?
          "If you can't join Shuffle lunch, please put leave button"
        else
          "Please put join or leave button"
        end
      [
        {
          text: attachments_text,
          fallback: "Your current Slack client doesn’t support Shuffle Lunch",
          callback_id: lunch.id,
          color: "#3AA3E3",
          attachment_type: "default",
          actions: actions
        }
      ]
    end

    def text
      if lunch.shuffled?
        "Shuffle lunch group of today\n#{lunch.groups.map(&:text).join("\n")}"
      else
        "Would you like to join the Shuffle Lunch today? #{lunch&.participant_ids_text}"
      end
    end

    def response_type
      "in_channel"
    end
  end
end

module Slack
  class Bot
    def initialize(slack_parameter)
      @bot = User.find_by!(username: Rails.configuration.x.slack.bot_username)
      @slack_parameter = slack_parameter
    end

    def reply
      lunch = Lunch.joins(:channel).where(shuffled_at: nil).find_by(event_id: slack_parameter.event_id, channels: { slack_id: slack_parameter.channel_id })
      if lunch_creating_request? && !lunch
        lunch = LunchBuilder.new(slack_parameter).build!
        post_message(lunch)
      elsif lunch_shuffle_request? && !lunch&.shuffled?
        LunchShuffler.new(lunch).shuffle!
        post_message(lunch)
      end
    end

    private

      attr_reader :bot, :slack_parameter

      def lunch_creating_request?
        /\A.*[<@#{bot.slack_id}>|<@#{bot.slack_id}\|#{bot.username}>] please create shuffle lunch/i.match?(slack_parameter.text)
      end

      def lunch_shuffle_request?
        /\A.*<@#{bot.slack_id}> please create/i.match?(slack_parameter.text)
      end

      def post_message(lunch)
        if lunch
          args = Slack::InteractiveComponent.new(lunch).as_json
          args[:channel] = slack_parameter.channel_name
        else
          args = { text: 'Todo message' }
        end
        Slack::Web::Client.new.chat_postMessage(args)
      end
  end
end

module Slack
  class EventSubscription
    def initialize(slack_parameter)
      @slack_parameter = slack_parameter
    end

    def as_json
      {}
    end

    def create!
      if app_mention? && new_event?
        event = Event.new(slack_id: slack_parameter.event_id)
        Slack::Bot.new(slack_parameter).reply if event.save
      end
    end

    private
      attr_reader :slack_parameter

      def app_mention?
        slack_parameter.event_type == 'app_mention'
      end

      def new_event?
        !Event.exists?(slack_id: slack_parameter.event_id)
      end
  end
end

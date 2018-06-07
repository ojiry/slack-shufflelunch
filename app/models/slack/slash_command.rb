module Slack
  class SlashCommand
    def initialize(slack_parameter)
      @slack_parameter = slack_parameter
    end

    def as_json
      if lunch
        Slack::InteractiveComponent.new(lunch).as_json
      else
        { text: "Can't create Shuffle Lunch" }
      end
    end

    def create!
      if @lunch = Lunch.joins(:channel).where(shuffled_at: nil).find_by(channels: { slack_id: slack_parameter.channel_id })
        @lunch.update(response_url: slack_parameter.response_url)
      else
        @lunch = LunchBuilder.new(slack_parameter).build!
      end
    end

    private

      attr_reader :slack_parameter, :lunch
  end
end

class Slack::SlashCommandsController < ApplicationController
  def create
    if lunch = Lunch.joins(:channel).where(shuffled_at: nil).find_by(channels: { slack_id: slack_parameter.channel_id })
      lunch.update(response_url: slack_parameter.response_url)
    else
      lunch = LunchBuilder.new(slack_parameter).build!
    end
    render json: Slack::InteractiveComponent.new(lunch).as_json
  end
end

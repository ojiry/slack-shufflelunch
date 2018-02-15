class Slack::SlashCommandsController < ApplicationController
  def create
    if lunch = Lunch.joins(:channel).where(shuffled_at: nil).find_by(channels: { slack_id: params[:channel_id] })
      lunch.update(response_url: params[:response_url])
    else
      lunch_builder = LunchBuilder.new(params)
      lunch = lunch_builder.build!
    end
    render json: InteractiveComponentBuilder.new(lunch).build
  end
end

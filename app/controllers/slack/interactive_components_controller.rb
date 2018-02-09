class Slack::InteractiveComponentsController < ApplicationController
  before_action :valid_slack_token

  def create
    lunch = Lunch.find(payload_params[:callback_id])
    user = User.find_or_create_by!(user_id: payload_params[:user][:id]) do |u|
      u.user_name = payload_params[:user][:name]
    end
    case payload_params[:actions].first[:value]
    when 'join'
      lunch.participations.create(user: user) if lunch.participations.none? { |p| p.user_id == user.id }
    when 'leave'
      lunch.participations.where(user_id: user.id).destroy_all
    when 'shuffle'
      GroupBuilder.new(lunch).build!
    end
    render json: InteractiveComponentBuilder.new(lunch).build
  end

  private

  def payload_params
    JSON.parse(params[:payload]).with_indifferent_access
  end

  def valid_slack_token
    unless payload_params[:token] == Rails.configuration.x.slack.verification_token
      head :forbidden
    end
  end
end

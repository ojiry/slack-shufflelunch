class Slack::InteractiveComponentsController < ApplicationController
  def create
    lunch = Lunch.find_by(id: payload_params[:callback_id])
    unless lunch
      render json: { text: 'This lunch has already been deleted' } and return
    end
    if lunch.shuffled?
      render json: InteractiveComponentBuilder.new(lunch).build and return
    end
    team = Team.find_or_create_by!(slack_id: payload_params[:team][:id]) do |t|
      t.domain = payload_params[:team][:domain]
    end
    user = User.find_or_create_by!(slack_id: payload_params[:user][:id]) do |u|
      u.username = payload_params[:user][:name]
      u.team = team
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
end

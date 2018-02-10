class Slack::InteractiveComponentsController < ApplicationController
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
end

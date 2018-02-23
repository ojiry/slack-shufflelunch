class Slack::InteractiveComponentsController < ApplicationController
  def create
    lunch = Lunch.joins(:channel).where(channels: { slack_id: slack_parameter.channel_id}).find_by(id: slack_parameter.callback_id)
    if lunch
      lunch.update(response_url: slack_parameter.response_url)
    else
      render json: { text: 'This lunch has already been deleted' } and return
    end
    case slack_parameter.actions.first[:value]
    when 'join'
      if !lunch.shuffled? && lunch.participations.none? { |p| p.user_id == user.id }
        lunch.participations.create(user: user)
      end
    when 'leave'
      lunch.participations.where(user_id: user.id).destroy_all
      GroupMember.joins(group: [:lunch]).merge(Lunch.shuffled.where(id: lunch.id)).where(user_id: user.id).destroy_all
    when 'shuffle'
      GroupBuilder.new(lunch).build! unless lunch.shuffled?
    when 'reshuffle'
      lunch.groups.destroy_all
      GroupBuilder.new(lunch).build!
    when 'bye'
      render json: { text: "See you! :wave:" } and return
    end
    render json: Slack::InteractiveComponent.new(lunch).as_json
  end

  private

    def team
      @team ||= Team.find_or_create_by!(slack_id: slack_parameter.team_id, domain: slack_parameter.team_domain)
    end

    def user
      @user ||= team.users.find_or_create_by!(slack_id: slack_parameter.user_id, username: slack_parameter.username)
    end
end

class LunchBuilder
  def initialize(slack_parameter)
    @slack_parameter = slack_parameter
  end

  def build!
    ActiveRecord::Base.transaction do
      lunch = creator.lunches.create!(channel_id: channel.id, response_url: slack_parameter.response_url)
      preset_users = User.where(slack_id: slack_parameter.preset_slack_usernames.map(&:slack_id))
      participated_slack_ids = []
      preset_users.each do |preset_user|
        lunch.participations.create!(user: preset_user)
        participated_slack_ids << preset_user.slack_id
      end
      slack_parameter.preset_slack_usernames.each do |slack_username|
        next if participated_slack_ids.include?(slack_username.slack_id)
        user = UserCreator.create!(slack_id: slack_username.slack_id, username: slack_username.username, team_id: team.id)
        lunch.participations.create!(user: user)
      end
      lunch
    end
  end

  private

    attr_reader :slack_parameter

    def channel
      @channel ||= team.channels.find_or_create_by!(slack_id: slack_parameter.channel_id, name: slack_parameter.channel_name)
    end

    def creator
      @creator ||= UserCreator.create!(slack_id: slack_parameter.user_id, username: slack_parameter.username, team_id: team.id)
    end

    def team
      @team ||= Team.find_or_create_by!(slack_id: slack_parameter.team_id, domain: slack_parameter.team_domain)
    end
end

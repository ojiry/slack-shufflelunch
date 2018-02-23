class LunchBuilder
  def initialize(slack_parameter)
    @slack_parameter = slack_parameter
  end

  def build!
    ActiveRecord::Base.transaction do
      lunch = creator.lunches.create!(channel_id: channel.id, response_url: slack_parameter.response_url)
      preset_users = User.where(slack_id: preset_usernames_by_slack_id.keys)
      participated_slack_ids = []
      preset_users.each do |preset_user|
        lunch.participations.create!(user: preset_user)
        participated_slack_ids << preset_user.slack_id
      end
      preset_usernames_by_slack_id.each do |slack_id, preset_username|
        next if participated_slack_ids.include?(slack_id)
        user = team.users.create!(slack_id: slack_id, username: preset_username)
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
      @creator ||= team.users.find_or_create_by!(slack_id: slack_parameter.user_id, username: slack_parameter.username)
    end

    def preset_usernames_by_slack_id
      slack_parameter.text.strip.split.each_with_object({}) do |preset_username, usernames|
        slack_id, username = preset_username.delete('<@>').split('|')
        usernames[slack_id] = username
      end
    end

    def team
      @team ||= Team.find_or_create_by!(slack_id: slack_parameter.team_id, domain: slack_parameter.team_domain)
    end
end

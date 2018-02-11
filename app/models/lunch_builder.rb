class LunchBuilder
  def initialize(params)
    @params = params
  end

  def build!
    ActiveRecord::Base.transaction do
      team = Team.find_or_create_by!(slack_id: params[:team_id]) do |t|
        t.domain = params[:team_domain]
      end
      channel = team.channels.find_or_create_by!(slack_id: params[:channel_id]) do |c|
        c.name = params[:channel_name]
      end
      user = User.find_or_create_by!(slack_id: params[:user_id]) do |u|
        u.username = params[:user_name]
        u.team = team
      end
      @lunch = user.lunches.create!(channel_id: channel.id)
      users = User.where(username: preset_usernames)
      users.each { |u| @lunch.participations.create!(user: u) }
      (preset_usernames - users.map(&:username)).each do |username|
        user_info = slack_client.users_info(user: "@#{username}").user
        user2 = User.find_or_create_by!(slack_id: user_info.id) do |u|
          u.username = user_info.name
          u.team = team
        end
        @lunch.participations.create!(user: user2)
      end
    end
    @lunch
  end

  private

  attr_reader :params

  def preset_usernames
    text.split.map { |username| username.delete('@') }.uniq
  end

  def slack_client
    @client ||= Slack::Web::Client.new
  end

  def text
    params[:text]&.strip || ''
  end
end

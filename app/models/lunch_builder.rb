class LunchBuilder
  def initialize(params)
    @params = params
  end

  def build!
    ActiveRecord::Base.transaction do
      user = User.find_or_create_by!(user_id: params[:user_id]) do |u|
        u.user_name = params[:user_name]
      end
      @lunch = user.lunches.create! do |l|
        l.team_id      = params[:team_id]
        l.team_domain  = params[:team_domain]
        l.channel_id   = params[:channel_id]
        l.channel_name = params[:channel_name]
      end
      @lunch.participations.create!(user: user)
      users = User.where(user_name: preset_user_names).where.not(id: user.id)
      users.each { |u| @lunch.participations.create!(user: u) }
      (preset_user_names - users.map(&:user_name)).each do |user_name|
        next if user_name == user.user_name
        user_info = slack_client.users_info(user: "@#{user_name}").user
        user2 = User.find_or_create_by!(user_id: user_info.id) do |u|
          u.user_name = user_info.name
        end
        @lunch.participations.create!(user: user2)
      end
    end
    @lunch
  end

  private

  attr_reader :params

  def preset_user_names
    text.split.map { |user_name| user_name.delete('@') }
  end

  def slack_client
    @client ||= Slack::Web::Client.new
  end

  def text
    params[:text]&.strip || ''
  end
end

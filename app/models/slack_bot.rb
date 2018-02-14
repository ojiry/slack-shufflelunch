class SlackBot
  def initialize(bot_username, params)
    @bot = User.find_by!(username: bot_username)
    @params = params
  end

  def reply
    if lunch_request?
      team = Team.find_or_create_by!(slack_id: params[:team_id]) do |t|
        t.domain = 'todo'
      end
      channel = team.channels.find_or_create_by!(slack_id: params[:event][:channel]) do |c|
        c.name = 'todo'
      end
      user = User.find_or_create_by!(slack_id: params[:event][:user]) do |u|
        u.username = 'todo'
        u.team = team
      end
      lunch = user.lunches.find_or_create_by!(channel_id: channel.id, shuffled_at: nil)
      usernames.each do |username|
        user_info = slack_client.users_info(user: "@#{username}").user
        user2 = User.find_or_create_by!(slack_id: user_info.id) do |u|
          u.username = user_info.name
          u.team = team
        end
        lunch.participations.create!(user: user2)
      end

      post_message(lunch)
    end
  end

  def post_message(lunch)
    args = InteractiveComponentBuilder.new(lunch).build
    args[:channel] = params[:event]['channel']
    Slack::Web::Client.new.chat_postMessage(args)
  end

  private

  attr_reader :params, :bot

  def lunch_request?
    !!match_data
  end

  def match_data
    /\A<@#{bot.slack_id}> please create shuffle lunch(.*)/i.match(params[:event][:text])
  end

  def usernames
    args = match_data[1].split.map { |username| username.split.delete('@') }.uniq
    args.shift == 'with' ? args : []
  end

  def slack_client
    @client ||= Slack::Web::Client.new
  end
end

class SlackBot
  def initialize(username, params)
    @user = User.find_by(username: username)
    @params = params
  end

  def reply
    return unless mention?
    Slack::Web::Client.new.chat_postMessage(channel: params[:event]['channel'], text: 'Hi!')
  end

  private

  attr_reader :params, :user

  def mention?
    /\A<@#{user.slack_id}>/.match?(params[:event][:text])
  end
end

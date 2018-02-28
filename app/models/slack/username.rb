module Slack
  class Username
    def initialize(username_text = '')
      @original_username_text = username_text
      @username_text = username_text.strip.delete('<@>')
    end

    def slack_id
      if mentioned_format?
        username_text.include?('|') ? username_text.split('|').first : username_text
      else
        User.find_by_username(username_text)&.slack_id.presence ||
          Slack::Web::Client.new.user_info(user: username_text).user.name
      end
    end

    def username
      if mentioned_format?
        if username_text.include?('|')
          username_text.split('|').last
        else
          User.find_by_slack_id(username_text)&.username.presence ||
            Slack::Web::Client.new.user_info(user: username_text).user.name
        end
      else
        User.find_by_username(username_text)&.username.presence ||
          Slack::Web::Client.new.user_info(user: username_text).user.name
      end
    end

    private

      attr_reader :original_username_text, :username_text

      def mentioned_format?
        /\A<@.*>\Z/.match?(original_username_text)
      end
  end
end

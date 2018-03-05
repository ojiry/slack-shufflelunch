module Slack
  class Parameter
    class << self
      def parse(params)
        new(params)
      end
    end

    def initialize(params)
      @params = params
      @parameter_type =
        if params[:command]
          :slash_commands
        elsif payload_params.present?
          :interactive_messages
        elsif params[:event]
          :event_subscriptions
        else
          :none
        end
    end

    def actions
      interactive_messages? ? payload_params[:actions] : []
    end

    def callback_id
      if slash_commands?
        params[:callback_id]
      elsif interactive_messages?
        payload_params[:callback_id]
      else
        nil
      end
    end

    def challenge
      params[:challenge]
    end

    def channel_id
      if slash_commands?
        params[:channel_id]
      elsif interactive_messages?
        payload_params[:channel][:id]
      elsif event_subscriptions?
        params[:event][:channel]
      else
        nil
      end
    end

    def channel_name
      if slash_commands?
        params[:channel_name]
      elsif interactive_messages?
        payload_params[:channel][:name]
      elsif event_subscriptions?
        Channel.find_by_slack_id(channel_id)&.name.presence ||
          Slack::Web::Client.new.channels_info(channel: channel_id).channel.name
      else
        nil
      end
    end

    def event_id
      if event_subscriptions?
        params[:event_id]
      else
        nil
      end
    end

    def event_type
      if event_subscriptions?
        params[:event][:type]
      else
        nil
      end
    end

    def preset_slack_usernames
      if slash_commands?
        text.strip.split.uniq.map { |username| Slack::Username.new(username) }
      elsif event_subscriptions?
        bot = User.find_by!(username: Rails.configuration.x.slack.bot_username)
        return [] unless match_data = /\A.*[<@#{bot.slack_id}>|<@#{bot.slack_id}\|#{bot.username}>] please create shuffle lunch with (.*)/i.match(text)
        match_data[1].split.uniq.map { |username| Slack::Username.new(username) }
      else
        []
      end
    end

    def response_url
      if slash_commands?
        params[:response_url]
      elsif interactive_messages?
        payload_params[:response_url]
      elsif event_subscriptions?
        'http://example.org/'
      else
        nil
      end
    end

    def team_domain
      if slash_commands?
        params[:team_domain]
      elsif interactive_messages?
        payload_params[:team][:domain]
      elsif event_subscriptions?
        Team.find_by_slack_id(team_id)&.domain.presence ||
          Slack::Web::Client.new.team_info.team.domain
      else
        nil
      end
    end

    def team_id
      if slash_commands?
        params[:team_id]
      elsif interactive_messages?
        payload_params[:team][:id]
      elsif event_subscriptions?
        params[:team_id]
      end
    end

    def text
      if slash_commands?
        params[:text]
      elsif event_subscriptions?
        params[:event][:text]
      else
        nil
      end
    end

    def type
      params[:type]
    end

    def token
      if slash_commands? || event_subscriptions?
        params[:token]
      elsif interactive_messages?
        payload_params[:token]
      else
        nil
      end
    end

    def user_id
      if slash_commands?
        params[:user_id]
      elsif interactive_messages?
        payload_params[:user][:id]
      elsif event_subscriptions?
        params[:event][:user]
      else
        nil
      end
    end

    def username
      if slash_commands?
        params[:user_name]
      elsif interactive_messages?
        payload_params[:user][:name]
      elsif event_subscriptions?
        User.find_by_slack_id(user_id)&.username.presence ||
          Slack::Web::Client.new.users_info(user: user_id).user.name
      else
        nil
      end
    end

    private

      attr_reader :params, :parameter_type

      def event_subscriptions?
        parameter_type == :event_subscriptions
      end

      def interactive_messages?
        parameter_type == :interactive_messages
      end

      def payload_params
        @payload_params ||= JSON.parse(params[:payload].presence || '{}').with_indifferent_access
      end

      def slash_commands?
        parameter_type == :slash_commands
      end
  end
end

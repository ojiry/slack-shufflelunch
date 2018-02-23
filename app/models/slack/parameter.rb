module Slack
  class Parameter
    class << self
      def parse(params)
        new(params)
      end
    end

    def initialize(params)
      @params = params
    end

    def actions
      payload_params[:actions] || {}
    end

    def callback_id
      params[:callback_id].presence || payload_params[:callback_id]
    end

    def channel_id
      params[:channel_id].presence || payload_params[:channel][:id]
    end

    def channel_name
      params[:channel_name].presence || payload_params[:channel][:name]
    end

    def response_url
      params[:response_url].presence || payload_params[:response_url]
    end

    def team_domain
      params[:team_domain].presence || payload_params[:team][:domain]
    end

    def team_id
      params[:team_id].presence || payload_params[:team][:id]
    end

    def text
      params[:text].presence || ''
    end

    def token
      params[:token].presence || payload_params[:token]
    end

    def user_id
      params[:user_id].presence || payload_params[:user][:id]
    end

    def username
      params[:user_name].presence || payload_params[:user][:name]
    end

    private

      attr_reader :params

      def payload_params
        @payload_params ||= JSON.parse(params[:payload].presence || '{}').with_indifferent_access
      end
  end
end

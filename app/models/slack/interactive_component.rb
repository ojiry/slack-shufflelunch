module Slack
  class InteractiveComponent
    def initialize(slack_parameter)
      @slack_parameter = slack_parameter
    end

    def as_json
      return { text: 'This lunch has already been deleted' } unless lunch

      if slack_parameter.actions.first[:value] == 'bye'
        { text: "See you! :wave:" }
      else
        Slack::InteractiveMessage.new(lunch).as_json
      end
    end

    def create!
      @lunch = Lunch.joins(:channel).where(channels: { slack_id: slack_parameter.channel_id}).find_by(id: slack_parameter.callback_id)
      return true unless @lunch
      @lunch.update(response_url: slack_parameter.response_url)
      case slack_parameter.actions.first[:value]
      when 'join'
        if !@lunch.shuffled? && @lunch.participations.none? { |p| p.user_id == user.id }
          @lunch.participations.create(user: user)
        end
      when 'leave'
        @lunch.participations.where(user_id: user.id).destroy_all
        GroupMember.joins(group: [:lunch]).merge(Lunch.shuffled.where(id: @lunch.id)).where(user_id: user.id).destroy_all
      when 'shuffle'
        LunchShuffler.new(@lunch).shuffle! unless @lunch.shuffled?
      when 'reshuffle'
        LunchShuffler.new(@lunch).reshuffle!
      end
    end

    private

      attr_reader :slack_parameter, :lunch

      def team
        @team ||= Team.find_or_create_by!(slack_id: slack_parameter.team_id, domain: slack_parameter.team_domain)
      end

      def user
        @user ||= team.users.find_or_create_by!(slack_id: slack_parameter.user_id, username: slack_parameter.username)
      end
  end
end

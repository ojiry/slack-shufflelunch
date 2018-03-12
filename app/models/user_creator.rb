class UserCreator
  class << self
    def create(slack_id:, username:, team_id:)
      new(slack_id: slack_id, username: username, team_id: team_id).create
    end

    def create!(slack_id:, username:, team_id:)
      new(slack_id: slack_id, username: username, team_id: team_id).create!
    end
  end

  def initialize(slack_id:, username:, team_id:)
    @slack_id = slack_id
    @username = username
    @team_id = team_id
  end

  def create
    create!
  rescue ActiveRecord::RecordInvalid
    false
  end

  def create!
    user = User.find_by(slack_id: slack_id, team_id: team_id)
    if user
      user.update!(username: username) unless user.username != username
    else
      user = User.create!(slack_id: slack_id, username: username, team_id: team_id
    end
    user
  end

  private

    attr_reader :slack_id, :username, :team_id
end

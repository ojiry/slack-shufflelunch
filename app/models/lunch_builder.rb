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
    end
    @lunch
  end

  private

  attr_reader :params
end

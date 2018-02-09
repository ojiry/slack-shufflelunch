class SlackBot
  def initialize(params)
    @params = params
  end

  def to_json
    { text: params[:text] }.to_json
  end

  private

  attr_reader :params
end

class Slack::InteractiveComponentsController < ApplicationController
  def create
    interactive_component = Slack::InteractiveComponent.new(slack_parameter)
    interactive_component.create!
    render json: interactive_component.as_json
  end
end

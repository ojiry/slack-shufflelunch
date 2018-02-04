class Slack::CommandsController < ApplicationController
  def create
    logger.info params.inspect
  end
end

class SlackController < ApplicationController
  def callback
    head :ok
  end
end

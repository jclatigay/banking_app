class HistoriesController < ApplicationController
  before_action :authenticate_user!

  def index
    @activities = current_user.activity_logs.recent
  end
end

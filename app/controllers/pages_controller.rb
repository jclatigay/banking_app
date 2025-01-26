class PagesController < ApplicationController
  before_action :authenticate_user!, only: [ :dashboard ]

  def home
  end

  def index
  end

  def dashboard
  end
end

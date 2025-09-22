class HomeController < ApplicationController
  before_action :authenticate_user!

  def index
    # current_user is available from Devise
  end
end

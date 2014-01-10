class WelcomeController < ApplicationController
  def index
  end

  def front
    redirect_to home_path if current_user
  end

  def download
  end

  def about
  end

  def pricing
  end
end
class WelcomeController < ApplicationController
  def index
  end

  def front
    if current_user && current_user.categories.size == 0 
      redirect_to start_use_path
    elsif current_user
      redirect_to home_path, :notice => notice
    end
  end

  def download
  end

  def about
  end

  def pricing
  end
end
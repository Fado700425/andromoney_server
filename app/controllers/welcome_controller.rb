class WelcomeController < ApplicationController
  def index
    if current_user && current_user.categories.size == 0
      redirect_to start_use_path
    elsif current_user
      redirect_to home_path, :notice => notice
    # workaround for zh and zh-TW landing page
    elsif [:zh, :"zh-TW",:ja , :en].include? I18n.locale
      render layout: "landing"
    else
      render layout: "application"
    end
  end
end

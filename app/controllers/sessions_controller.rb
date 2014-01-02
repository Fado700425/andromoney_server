class SessionsController < ApplicationController
  def create
    auth = request.env["omniauth.auth"]
    user = User.where(:email => auth["info"]["email"]).first_or_initialize(
      :refresh_token => auth["credentials"]["refresh_token"],
      :access_token => auth["credentials"]["token"],
      :expires => auth["credentials"]["expires_at"],
      :name => auth["info"]["name"],
      :email => auth["info"]["email"],
      :uid => auth["uid"],
      :provider => auth["provider"]
    )

    if user.new_record?
      @create_first_use_message = true
    end
    
    if user.save
      user.messages.create(context: "恭喜你開始使用 AndroMoney!") if @create_first_use_message
      session[:user_id] = user.id
      flash[:info] = "Signed in!"
      redirect_to home_path, :notice => notice
    else
      raise "Failed to login"
    end
  end

  def destroy
    session[:user_id] = nil
    flash[:info] = "Signed out!"
    redirect_to root_url
  end
end
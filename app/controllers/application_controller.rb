class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  helper_method :current_user
  
  before_action :set_locale
  
  def current_user
    @current_user ||= User.find(session[:user_id]) if session[:user_id]
  end

  def require_user
    unless current_user
      flash["danger"] = t('required_for_login_user')
      redirect_to root_path
    end
  end

  def default_url_options(options={})
    logger.debug "default_url_options is passed options: #{options.inspect}\n"
    { locale: I18n.locale }
  end

private
  
  def set_locale
    if params[:locale] && ["en", "zh-TW","zh"].include?( params[:locale] )
      session[:locale] = params[:locale]
    end
    I18n.locale = session[:locale] || extract_locale_from_accept_language_header
    ["zh-TW","zh"].include?( I18n.locale.to_s )? @country_id = 1 : @country_id = 2
  end

  def extract_locale_from_accept_language_header
    request.env['HTTP_ACCEPT_LANGUAGE'].scan(/^[a-z]{2}/).first if request.env['HTTP_ACCEPT_LANGUAGE']
  end
end

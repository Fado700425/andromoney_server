class AccountsController < ApplicationController

  layout 'account'

  def index
  end

  def info
  end

  def message
    @messages = current_user.messages
    Message.update_all("is_read = true", "user_id = #{current_user.id}")
  end
end
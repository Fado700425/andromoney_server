class AccountsController < ApplicationController

  layout 'account'

  def index
  end

  def info
  end

  def delete
    begin 
      ActiveRecord::Base.transaction do
        Record.delete_all(user_id: current_user.id)
        Category.delete_all(user_id: current_user.id)
        Payee.delete_all(user_id: current_user.id)
        Currency.delete_all(user_id: current_user.id)
        Payment.delete_all(user_id: current_user.id)
        Period.delete_all(user_id: current_user.id)
        Project.delete_all(user_id: current_user.id)
        Pref.delete_all(user_id: current_user.id)
        Subcategory.delete_all(user_id: current_user.id)
        Device.delete_all(user_id: current_user.id)
        Message.delete_all(user_id: current_user.id)
        User.delete(current_user.id)
      end
    rescue
      flash[:danger] = t('setting.delete_fail')
      redirect_to edit_account_path(1)
    else
      session[:user_id] = nil
      reset_session
      flash[:success] = t('setting.delete_success')
      redirect_to root_url
    end
  end

  def message
    @messages = current_user.messages
    Message.update_all("is_read = true", "user_id = #{current_user.id}")
  end
end
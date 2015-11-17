class AccountsController < ApplicationController

  layout 'account'

  def index
  end

  def info
  end

  def main_currency
    @currencies = getCurrencies params[:searchWord]
    if(params[:searchWord] != nil)
      render 'user_currencies.js.erb'
    end
  end

  def update_main_currency
    if(Rails.env == 'production' && !checkCanUpdate)
      flash[:danger] = t('account.cannot_update_multi_in_one_day')
      redirect_to :controller => 'accounts', :action => 'main_currency'
      return
    end
    selectedCode = params[:selected_currency]
    begin
      ActiveRecord::Base.transaction do
        max = Currency.select(:sequence_status).where('user_id = ?', current_user.id).order(sequence_status: :desc).limit(1).first.sequence_status
        current_user.get_main_currency.update(sequence_status: max + 1, device_uuid: "computer")
        selectedCurrency = Currency.find_by('user_id = ? AND currency_code = ?', current_user.id, selectedCode)
        selectedCurrency.update(sequence_status: 0, device_uuid: "computer")

        updateRecordsAmount(selectedCurrency.rate) 
      end
    rescue
      flash[:danger] = t('account.update_currency_fail')
    else
      flash[:success] = t('account.update_currency_success')
    end
    redirect_to :controller => 'accounts', :action => 'main_currency'
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
      flash[:danger] = t('account.delete_fail')
      redirect_to edit_account_path(1)
    else
      session[:user_id] = nil
      reset_session
      flash[:success] = t('account.delete_success')
      redirect_to root_url
    end
  end

  def message
    @messages = current_user.messages
    Message.update_all("is_read = true", "user_id = #{current_user.id}")
  end

  private

  def checkCanUpdate
    yesterday = Time.now - 1.day
    updatedToday = current_user.currencies.where(["updated_at > ?", yesterday.end_of_day])
    return updatedToday.size == 0
  end

  def getCurrencies(searchWord = nil)
    currencies = Currency.where(user_id: current_user.id, is_delete: false)
    if(searchWord != nil)
      currencies = currencies.where("currency_code like ? OR currency_remark like ?", "%#{searchWord}%", "%#{searchWord}%")
    end
    return currencies.order("currency_code")
  end

  def updateRecordsAmount(nowRate)
    # update amount_to_main
    sql = "update record_table a join currency_table b on (a.currency_code = b.currency_code) and (a.user_id = b.user_id) set amount_to_main = mount / rate * #{nowRate}, " + 
          "a.device_uuid = 'computer', a.updated_at = NOW(), a.update_time = NOW() where a.user_id = #{current_user.id}"
    ActiveRecord::Base.connection.execute(sql)
    # update in_amount, in_currency, out_amount, out_currency
    sql = "update record_table a join payment_table b on (a.in_payment = b.hash_key) and (a.user_id = b.user_id) " + 
          "join currency_table c on (b.currency_code = c.currency_code) and (b.user_id = c.user_id) join currency_table d on (a.currency_code = d.currency_code) " + 
          "and  (c.user_id = d.user_id) set a.in_amount = (a.mount / d.rate * c.rate), a.in_currency = b.currency_code, a.device_uuid = 'computer', " + 
          "a.updated_at = NOW(), a.update_time = NOW() where a.user_id = #{current_user.id} and a.in_payment is not null and a.currency_code != b.currency_code and b.currency_code is not null"
    ActiveRecord::Base.connection.execute(sql)

    sql = "update record_table a join payment_table b on (a.out_payment = b.hash_key) and (a.user_id = b.user_id) " + 
          "join currency_table c on (b.currency_code = c.currency_code) and (b.user_id = c.user_id) join currency_table d on (a.currency_code = d.currency_code) " + 
          "and  (c.user_id = d.user_id) set a.out_amount = (a.mount / d.rate * c.rate), a.out_currency = b.currency_code, a.device_uuid = 'computer', " + 
          "a.updated_at = NOW(), a.update_time = NOW() where a.user_id = #{current_user.id} and a.out_payment is not null and a.currency_code != b.currency_code and b.currency_code is not null"
    ActiveRecord::Base.connection.execute(sql)
  end
end
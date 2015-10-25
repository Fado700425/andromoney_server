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
    if(!checkCanUpdate)
      flash[:danger] = t('account.cannot_update_multi_in_one_day')
      redirect_to :controller => 'accounts', :action => 'main_currency'
      return
    end
    selectedCode = params[:selected_currency]
    begin
      ActiveRecord::Base.transaction do
        max = Currency.maximum(:sequence_status, :conditions => ['user_id = ?', current_user.id])
        current_user.get_main_currency.update(sequence_status: max + 1)
        selectedCurrency = Currency.where('user_id = ? AND currency_code = ?', current_user.id, selectedCode)[0]
        selectedCurrency.update(sequence_status: 0)

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
    rateHash = Hash.new
    codes = current_user.records.select(:currency_code).uniq.pluck(:currency_code)

    codes.each { |code| 
      rateHash[code] = current_user.currencies.select(:rate).where(currency_code: code).pluck(:rate)[0]
    }

    sql = "Update record_table SET amount_to_main = (CASE currency_code "
    rateHash.each do |key, rate| 
      sql += "when '#{key}' THEN mount / #{rate} * #{nowRate} "
    end
    sql += " END) where user_id = #{current_user.id}"
    ActiveRecord::Base.connection.execute(sql)
  end
end
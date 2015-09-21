class PaymentCell < Cell::ViewModel
  cache :show do |options|
    current_user ||= User.find(session[:user_id]) if session[:user_id]
    latestPayment = Payment.select(:update_time).where(user_id: current_user.id).order('update_time DESC').limit(1)
    latestRecord = Record.select(:update_time).where(user_id: current_user.id).order('update_time DESC').limit(1)

    if(latestPayment.size == 1)
      paymentKey = latestPayment[0].update_time.strftime("%Y%m%d%H%M%S")
    else
      paymentKey = 'PAYMENT_EMPTY'
    end

    if(latestRecord.size == 1)
      recordKey = latestRecord[0].update_time.strftime("%Y%m%d%H%M%S")
    else
      recordKey = 'RECORD_EMPTY'
    end

    current_user.id.to_s + paymentKey + recordKey + current_user.get_main_currency.currency_code
  end

  def show(current_user, icon_path)
    @payments = Payment.where(user_id: current_user.id).not_hidden.order("order_no")
    @user = current_user
    @icon_path = icon_path
    render
  end
end
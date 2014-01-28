class PaymentsController < ApplicationController

  layout 'account'

  def index
    @payments = Payment.where(user_id: current_user.id).not_hidden
  end

  def update
    payment = Payment.find(params[:payment_id])
    payment.update(payment_param)
    init  = payment.init_record

    unless init
      init = Record.new(in_payment: payment.hash_key, category: "SYSTEM", sub_category: "INIT_AMOUNT", user_id: current_user.id, currency_code: payment.currency_code, hash_key: SecureRandom.urlsafe_base64, device_uuid: "computer", date: DateTime.parse('1010-01-01 00:00:00'), update_time: Time.now)
    end

    init.mount = params[:initial_amount].to_f
    init.amount_to_main = init.calculate_record_amount(current_user.get_main_currency)
    init.save
    
    payment.device_uuid = "computer"
    payment.update_time = DateTime.now.utc
    payment.save
    
    redirect_to payments_path
  end

  def create
    payment = Payment.new(payment_param)
    payment.hash_key = SecureRandom.urlsafe_base64
    payment.user_id = current_user.id
    payment.currency_code = current_user.get_main_currency.currency_code
    payment.rate = 1
    payment.device_uuid = "computer"
    payment.update_time = DateTime.now.utc
    payment.order_no = 1000
    payment.total = 0
    payment.hidden = 0
    payment.save
    init_record = Record.create(in_payment: payment.hash_key, category: "SYSTEM", sub_category: "INIT_AMOUNT", user_id: current_user.id, currency_code: payment.currency_code, hash_key: SecureRandom.urlsafe_base64, device_uuid: "computer", date: DateTime.parse('1010-01-01 00:00:00'), update_time: Time.now)
    init_record.mount = params[:initial_amount].to_f
    init_record.amount_to_main = init_record.calculate_record_amount(current_user.get_main_currency)
    init_record.save

    redirect_to payments_path
  end

private
  def payment_param
    params.require(:payment).permit(:kind,:date,:payment_name)
  end
end
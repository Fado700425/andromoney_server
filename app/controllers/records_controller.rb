class RecordsController < ApplicationController

  layout 'account'

  def new
    @record = Record.new
    @expense_category = Category.where(type: 20, user_id: current_user.id).each_slice(3).to_a
    @income_category = Category.where("type = 10 and hash_key != 'SYSTEM' and user_id = #{current_user.id}").each_slice(3).to_a
    @transfer_category = Category.where(type: 30, user_id: current_user.id).each_slice(3).to_a
    @payments = Payment.where(user_id: current_user.id).each_slice(3).to_a
    @payees = Payee.where(user_id: current_user.id).each_slice(3).to_a
    @projects = Project.where(user_id: current_user.id).each_slice(3).to_a
    @subcategories = Subcategory.where(id_category: @expense_category.first[0].hash_key, user_id: current_user.id).each_slice(3).to_a
    @income_subcategories = Subcategory.where(id_category: @income_category.first[0].hash_key, user_id: current_user.id).each_slice(3).to_a
    @transfer_subcategories = Subcategory.where(id_category: @transfer_category.first[0].hash_key, user_id: current_user.id).each_slice(3).to_a
  end

  def create
    @record = Record.new(record_param)
    @record.user_id = current_user.id
    @record.hash_key = SecureRandom.urlsafe_base64
    set_record_submit_value(@record)

    if @record.save
      flash[:notice] = "Create success"      
    else
      flash[:error] = "Create fail!"
    end
    redirect_to records_path(month_from_now: params[:month_from_now])
  end

  def transfer
    record = Record.new(record_param)
    record.user_id = current_user.id
    record.hash_key = SecureRandom.urlsafe_base64

    set_tranfer_record_value(record)
    

    if record.save
      flash[:notice] = "Create success"      
    else
      flash[:error] = "Create fail!"
    end
    redirect_to records_path(month_from_now: params[:month_from_now])
    
  end

  def transfer_edit
    @record = Record.find(params[:record_id])
    @payments = Payment.where(user_id: current_user.id).each_slice(3).to_a
    @projects = Project.where(user_id: current_user.id).each_slice(3).to_a
    @transfer_category = Category.where(type: 30, user_id: current_user.id).each_slice(3).to_a
    @transfer_subcategories = Subcategory.where(id_category: @transfer_category.first[0].hash_key, user_id: current_user.id).each_slice(3).to_a
  end

  def transfer_update
    record = Record.find(params[:record_id])
    if record.update(record_param)
      set_tranfer_record_value(record)
      record.save
    end
    redirect_to records_path(month_from_now: params[:month_from_now])
  end

  def update
    record = Record.find(params[:id])
    
    record.in_amount = nil
    record.out_amount = nil
    record.in_currency = nil
    record.out_currency = nil

    if record.update(record_param)
      set_record_submit_value(record)
      record.save
    end
    redirect_to records_path(month_from_now: params[:month_from_now])
  end

  def index
    
    if params[:month_from_now]
      @records = current_user.records.month_from_now(params[:month_from_now].to_i)
    else
      @records = current_user.records.month_from_now(0)
    end

  end

  def edit
    @record = Record.find(params[:id])
    @expense_category = Category.where(type: 20, user_id: current_user.id).each_slice(3).to_a
    @income_category = Category.where("type = 10 and hash_key != 'SYSTEM' and user_id = #{current_user.id}").each_slice(3).to_a
    @payments = Payment.where(user_id: current_user.id).each_slice(3).to_a
    @payees = Payee.where(user_id: current_user.id).each_slice(3).to_a
    @projects = Project.where(user_id: current_user.id).each_slice(3).to_a
    @subcategories = Subcategory.where(id_category: @record.category, user_id: current_user.id).each_slice(3).to_a
    @income_subcategories = Subcategory.where(id_category: @record.category, user_id: current_user.id).each_slice(3).to_a
  end

  def destroy
    Record.delete(params[:id])
    flash[:notice] = "delete success"
    redirect_to records_path(month_from_now: params[:month_from_now])
  end

private
  def record_param
    params.require(:record).permit(:mount,:date,:in_payment,:out_payment,:payee,:project,:category,:sub_category,:remark,:in_amount,:out_amount,:fee)
  end

  def set_tranfer_record_value(record)
    record.mount = 0 unless record.mount

    record.device_uuid = "computer"
    record.update_time = DateTime.now.utc
    record.project = Project.find_by(project_name: record.project, user_id: current_user.id).hash_key if record.project.present?

    payment = Payment.find_by(payment_name: record.out_payment, user_id: current_user.id)
    record.out_payment = payment.hash_key
    init_record = Record.find_by(out_payment: payment.hash_key, category: "SYSTEM", sub_category: "INIT_AMOUNT", user_id: current_user.id)
    record.currency_code = (init_record) ? init_record.currency_code : current_user.get_main_currency.currency_code
    record.amount_to_main = record.calculate_record_amount(current_user.get_main_currency)

    if record.currency_code != record.record_out_payment.currency_code
      record.out_currency = record.record_out_payment.currency_code
      record.out_amount = record.calculate_record_amount(Currency.find_by(currency_code: record.record_out_payment.currency_code, user_id: current_user.id))
    end

    payment = Payment.find_by(payment_name: record.in_payment, user_id: current_user.id) 
    record.in_payment = payment.hash_key if record.in_payment

    if record.currency_code != record.record_in_payment.currency_code
      record.in_currency = record.record_in_payment.currency_code
      record.in_amount = record.calculate_record_amount(Currency.find_by(currency_code: record.record_in_payment.currency_code, user_id: current_user.id)) unless record.in_amount
    end
  end

  def set_record_submit_value(record)
    record.mount = 0 unless record.mount

    if record.out_payment
      payment = Payment.find_by(payment_name: record.out_payment, user_id: current_user.id)
      record.out_payment = payment.hash_key
      init_record = Record.find_by(in_payment: payment.hash_key, category: "SYSTEM", sub_category: "INIT_AMOUNT", user_id: current_user.id)
      record.currency_code = (init_record) ? init_record.currency_code : current_user.get_main_currency.currency_code
      record.amount_to_main = record.calculate_record_amount(current_user.get_main_currency)

      if record.currency_code != record.record_out_payment.currency_code
        record.out_currency = record.record_out_payment.currency_code
        record.out_amount = record.calculate_record_amount(Currency.find_by(currency_code: record.record_out_payment.currency_code, user_id: current_user.id))
      end
    end

    if record.in_payment
      payment = Payment.find_by(payment_name: record.in_payment, user_id: current_user.id) 
      record.in_payment = payment.hash_key if record.in_payment
      init_record = Record.find_by(in_payment: payment.hash_key, category: "SYSTEM", sub_category: "INIT_AMOUNT", user_id: current_user.id)
      record.currency_code = (init_record) ? init_record.currency_code : current_user.get_main_currency.currency_code
      record.amount_to_main = record.calculate_record_amount(current_user.get_main_currency)

      if record.currency_code != record.record_in_payment.currency_code
        record.in_currency = record.record_in_payment.currency_code
        record.in_amount = record.calculate_record_amount(Currency.find_by(currency_code: record.record_in_payment.currency_code, user_id: current_user.id))
      end
    end
    
    record.project = Project.find_by(project_name: record.project, user_id: current_user.id).hash_key if record.project.present?
    record.payee = Payee.find_by(payee_name: record.payee, user_id: current_user.id).hash_key if record.payee.present?
    
    record.device_uuid = "computer"
    record.update_time = DateTime.now.utc
    
  end
end
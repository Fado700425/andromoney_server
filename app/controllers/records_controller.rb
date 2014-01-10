class RecordsController < ApplicationController

  layout 'account'

  def new
    @record = Record.new
    @expense_category = Category.where(type: 20, user_id: current_user.id).each_slice(3).to_a
    @income_category = Category.where("type = 10 and hash_key != 'SYSTEM' and user_id = #{current_user.id}").each_slice(3).to_a
    @payments = Payment.where(user_id: current_user.id).each_slice(3).to_a
    @payees = Payee.where(user_id: current_user.id).each_slice(3).to_a
    @projects = Project.where(user_id: current_user.id).each_slice(3).to_a
    @subcategories = Subcategory.where(id_category: @expense_category.first[0].hash_key, user_id: current_user.id).each_slice(3).to_a
    @income_subcategories = Subcategory.where(id_category: @income_category.first[0].hash_key, user_id: current_user.id).each_slice(3).to_a
  end

  def create
    @record = Record.new(record_param)
    @record.user_id = current_user.id

    if @record.out_payment
      payment = Payment.find_by(payment_name: @record.out_payment)
      @record.out_payment = payment.hash_key
      init_record = Record.find_by(in_payment: payment.hash_key, category: "SYSTEM", sub_category: "INIT_AMOUNT")
      @record.currency_code = (init_record) ? init_record.currency_code : current_user.get_main_currency.currency_code
      @record.amount_to_main = @record.calculate_record_amount(current_user.get_main_currency)
    end

    if @record.in_payment  
      payment = Payment.find_by(payment_name: @record.in_payment) 
      @record.in_payment = payment.hash_key if @record.in_payment
      init_record = Record.find_by(in_payment: payment.hash_key, category: "SYSTEM", sub_category: "INIT_AMOUNT")
      @record.currency_code = (init_record) ? init_record.currency_code : current_user.get_main_currency.currency_code
      @record.amount_to_main = @record.calculate_record_amount(current_user.get_main_currency)
    end
    
    @record.project = Project.find_by(project_name: @record.project).hash_key if @record.project.present?
    @record.payee = Payee.find_by(payee_name: @record.payee).hash_key if @record.payee.present?
    @record.hash_key = SecureRandom.urlsafe_base64
    @record.device_uuid = "computer"
    @record.update_time = DateTime.now.utc
    if @record.save
      flash[:notice] = "Create success"      
    else
      flash[:error] = "Create fail!"
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

  def edit_remark
    record = Record.find_by(user_id: current_user.id, id: params[:record_id])
    if record
      record.remark = params[:remark]
      record.update_time = DateTime.now.utc
      record.uuid = "computer"
      record.save
    end
    redirect_to records_path(month_from_now: params[:month_from_now])
  end

  def destroy
    Record.delete(params[:id])
    flash[:notice] = "delete success"
    redirect_to records_path(month_from_now: params[:month_from_now])
  end

private
  def record_param
    params.require(:record).permit(:mount,:date,:in_payment,:out_payment,:payee,:project,:category,:sub_category,:remark)
  end
end
class RecordsController < ApplicationController
  helper_method :sort_column, :sort_direction

  layout 'account'

  def new
    @record = Record.new
    @expense_category = Category.where(user_id: current_user.id,type: 20, hash_key:Subcategory.select("id_category").where(user_id: current_user.id)).not_hidden.each_slice(3).to_a
    @income_category = Category.where(user_id: current_user.id,type: 10, hash_key:Subcategory.select("id_category").where(user_id: current_user.id)).where.not(hash_key:"SYSTEM").not_hidden.each_slice(3).to_a
    @transfer_category = Category.where(type: 30, user_id: current_user.id, hash_key:Subcategory.select("id_category").where(user_id: current_user.id)).not_hidden.each_slice(3).to_a
    @payments = Payment.where(user_id: current_user.id).not_hidden.each_slice(3).to_a
    @payees = Payee.where(user_id: current_user.id).not_hidden.each_slice(3).to_a
    @projects = Project.where(user_id: current_user.id).not_hidden.each_slice(3).to_a
    @subcategories = Subcategory.where(id_category: @expense_category.first[0].hash_key, user_id: current_user.id).not_hidden.each_slice(3).to_a
    @income_subcategories = Subcategory.where(id_category: @income_category.first[0].hash_key, user_id: current_user.id).not_hidden.each_slice(3).to_a
    @transfer_subcategories = Subcategory.where(id_category: @transfer_category.first[0].hash_key, user_id: current_user.id).not_hidden.each_slice(3).to_a
  end

  def create
    @record = Record.new(record_param)
    @record.user_id = current_user.id
    @record.hash_key = 'test' + SecureRandom.urlsafe_base64
    set_record_submit_value(@record)

    if @record.save
      flash["success"] = t('record.success_create')     
    else
      flash["danger"] = t('record.fail_create')
    end
    redirect_to records_path(month_from_now: params[:month_from_now])
  end

  def transfer
    record = Record.new(record_param)
    record.user_id = current_user.id
    record.hash_key = SecureRandom.urlsafe_base64

    set_tranfer_record_value(record)
    

    if record.save
      flash["success"] = t('record.success_create')   
    else
      flash["danger"] = t('record.fail_create')
    end
    redirect_to records_path(month_from_now: params[:month_from_now])
    
  end

  def transfer_edit
    @record = Record.find(params[:record_id])
    @payments = Payment.where(user_id: current_user.id).not_hidden.each_slice(3).to_a
    @projects = Project.where(user_id: current_user.id).not_hidden.each_slice(3).to_a
    @transfer_category = Category.where(type: 30, user_id: current_user.id).not_hidden.each_slice(3).to_a
    @transfer_subcategories = Subcategory.where(id_category: @transfer_category.first[0].hash_key, user_id: current_user.id).not_hidden.each_slice(3).to_a
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

    if current_user.categories.size > 0

      if params[:month_from_now]
        if params[:sort] == "payment"
          @records = current_user.records.not_delete.month_from_now(params[:month_from_now].to_i).order("in_payment,out_payment " + sort_direction)
        else
          @records = current_user.records.not_delete.month_from_now(params[:month_from_now].to_i).order(sort_column + " " + sort_direction)
        end
      else
        if params[:sort] == "payment"
          @records = current_user.records.not_delete.month_from_now(0).order("in_payment,out_payment " + sort_direction)
        else
          @records = current_user.records.not_delete.month_from_now(0).order(sort_column + " " + sort_direction)
        end
      end

      if params[:sort] == "category" && params[:direction] == "asc"
        @records = @records.sort{ |x,y| x.category_order_num <=> y.category_order_num }
      elsif params[:sort] == "category" && params[:direction] == "desc"
        @records = @records.sort{ |x,y| y.category_order_num <=> x.category_order_num }
      end


    else
      redirect_to start_use_path
    end

  end

  def edit
    @record = Record.find(params[:id])
    @expense_category = Category.where(type: 20, user_id: current_user.id).not_hidden.each_slice(3).to_a
    @income_category = Category.where("type = 10 and hash_key != 'SYSTEM' and user_id = #{current_user.id}").not_hidden.each_slice(3).to_a
    @payments = Payment.where(user_id: current_user.id).not_hidden.each_slice(3).to_a
    @payees = Payee.where(user_id: current_user.id).not_hidden.each_slice(3).to_a
    @projects = Project.where(user_id: current_user.id).not_hidden.each_slice(3).to_a
    @subcategories = Subcategory.where(id_category: @record.category, user_id: current_user.id).not_hidden.each_slice(3).to_a
    @income_subcategories = Subcategory.where(id_category: @record.category, user_id: current_user.id).not_hidden.each_slice(3).to_a
  end

  def destroy
    record = Record.find(params[:id])
    record.is_delete = true
    record.device_uuid = "computer"
    record.update_time = DateTime.now.utc
    record.save

    flash["success"] = t('record.delete')
    redirect_to records_path(month_from_now: params[:month_from_now])
  end

private
  
  def sort_column
    column_name = Record.column_names.include?(params[:sort]) ? params[:sort] : "date"
    column_name = "payment" if params[:sort] == "payment"
    column_name
  end
  
  def sort_direction
    %w[asc desc].include?(params[:direction]) ? params[:direction] : "asc"
  end

  def record_param
    params.require(:record).permit(:mount,:date,:in_payment,:out_payment,:payee,:project,:category,:sub_category,:remark,:in_amount,:out_amount,:fee)
  end

  def set_tranfer_record_value(record)
    record.mount = 0 unless record.mount

    record.device_uuid = "computer"
    record.update_time = DateTime.now.utc
    record.project = Project.find_by(project_name: record.project, user_id: current_user.id).hash_key if record.project.present?

    out_payment_name = record.out_payment.split('(')[0]
    payment = Payment.find_by(payment_name: out_payment_name, user_id: current_user.id)
    record.out_payment = payment.hash_key
    init_record = Record.find_by(in_payment: payment.hash_key, category: "SYSTEM", sub_category: "INIT_AMOUNT", user_id: current_user.id)
    record.currency_code = (init_record) ? init_record.currency_code : current_user.get_main_currency.currency_code
    record.amount_to_main = record.calculate_record_amount(current_user.get_main_currency)

    if record.currency_code != record.record_out_payment.display_currency_code(current_user)
      record.out_currency = record.record_out_payment.display_currency_code(current_user)
      record.out_amount = record.calculate_record_amount(Currency.find_by(currency_code: record.record_out_payment.display_currency_code(current_user), user_id: current_user.id))
    end

    if record.in_payment
      in_payment_name = record.in_payment.split('(')[0]
      payment = Payment.find_by(payment_name: in_payment_name, user_id: current_user.id) 
      record.in_payment = payment.hash_key
    end

    if record.currency_code != record.record_in_payment.display_currency_code(current_user)
      record.in_currency = record.record_in_payment.display_currency_code(current_user)
      record.in_amount = record.calculate_record_amount(Currency.find_by(currency_code: record.record_in_payment.display_currency_code(current_user), user_id: current_user.id)) unless record.in_amount
    end
  end

  def set_record_submit_value(record)
    record.mount = 0 unless record.mount

    if record.out_payment
      out_payment_name = record.out_payment.split('(')[0]
      payment = Payment.find_by(payment_name: out_payment_name, user_id: current_user.id)
      record.out_payment = payment.hash_key
      init_record = Record.find_by(in_payment: payment.hash_key, category: "SYSTEM", sub_category: "INIT_AMOUNT", user_id: current_user.id)
      record.currency_code = (init_record) ? init_record.currency_code : current_user.get_main_currency.currency_code
      record.amount_to_main = record.calculate_record_amount(current_user.get_main_currency)

      if record.currency_code != record.record_out_payment.display_currency_code(current_user)
        record.out_currency = record.record_out_payment.display_currency_code(current_user)
        record.out_amount = record.calculate_record_amount(Currency.find_by(currency_code: record.record_out_payment.display_currency_code(current_user), user_id: current_user.id))
      end
    end

    if record.in_payment
      in_payment_name = record.in_payment.split('(')[0]
      payment = Payment.find_by(payment_name: in_payment_name, user_id: current_user.id) 
      record.in_payment = payment.hash_key if record.in_payment
      init_record = Record.find_by(in_payment: payment.hash_key, category: "SYSTEM", sub_category: "INIT_AMOUNT", user_id: current_user.id)
      record.currency_code = (init_record) ? init_record.currency_code : current_user.get_main_currency.currency_code
      record.amount_to_main = record.calculate_record_amount(current_user.get_main_currency)

      if record.currency_code != record.record_in_payment.display_currency_code(current_user)
        record.in_currency = record.record_in_payment.display_currency_code(current_user)
        record.in_amount = record.calculate_record_amount(Currency.find_by(currency_code: record.record_in_payment.display_currency_code(current_user), user_id: current_user.id))
      end
    end
    
    record.project = Project.find_by(project_name: record.project, user_id: current_user.id).hash_key if record.project.present?
    record.payee = Payee.find_by(payee_name: record.payee, user_id: current_user.id).hash_key if record.payee.present?
    
    record.device_uuid = "computer"
    record.update_time = DateTime.now.utc
    
  end
end
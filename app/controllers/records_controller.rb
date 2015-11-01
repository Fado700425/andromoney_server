class RecordsController < ApplicationController
  helper_method :sort_column, :sort_direction

  layout 'account'

  def new
    @record = Record.new
    fetch_variables_for_records
    @record.date ||= DateTime.now.utc.strftime("%Y/%m/%d/ %H:%M") # if user didn't input :date, this will set default value.
  end

  def edit
    @record = Record.find(params[:id])
    fetch_variables_for_records
  end

  def create
    @record = Record.new(record_param)
    @record.user_id = current_user.id
    @record.hash_key = SecureRandom.urlsafe_base64
    @record.date ||= DateTime.now.utc.strftime("%Y/%m/%d/ %H:%M") # if user didn't input :date, this will set default value.
    set_record_submit_value(@record)

    if @record.save
      flash["success"] = t('record.success_create')
      @array = params[:submit_type]
      if !@array.blank? && (@array == "to_new")
        @record = Record.new
        fetch_variables_for_records
        redirect_to new_record_path
      else
        redirect_to records_path(month_from_now: params[:month_from_now])
      end
    else
      flash.now["danger"] = t('record.fail_create')
      fetch_variables_for_records
      render 'records/new'
    end
  end

  def update
    @record = Record.find(params[:id])
    @record.update(record_param)
    set_record_submit_value(@record)

    if @record.save
      flash["success"] = t('record.success_create')
      @array = params[:submit_type]
      if !@array.blank? && (@array == "to_new")
        @record = Record.new
        fetch_variables_for_records
        redirect_to new_record_path
      else
        redirect_to records_path(month_from_now: params[:month_from_now])
      end
    else
      flash.now["danger"] = t('record.fail_create')
      fetch_variables_for_records
      render 'edit'
    end
  end

  def index
    if request.xhr?
      if params[:start].nil?
        if params[:view].downcase.include? 'month'
          start_date = Time.zone.now.at_beginning_of_month
        elsif params[:view].downcase.include? 'week'
          start_date = Time.zone.now.at_beginning_of_week
        elsif params[:view].downcase.include? 'day'
          start_date = Time.zone.now.at_beginning_of_day
        end
      else
        start_date = params[:start].to_time().at_beginning_of_day
      end
      if params[:end].nil?
        if params[:view].downcase.include? 'month'
          start_date = Time.zone.now.at_end_of_month
        elsif params[:view].downcase.include? 'week'
          start_date = Time.zone.now.at_end_of_week
        elsif params[:view].downcase.include? 'day'
          start_date = Time.zone.now.at_end_of_day
        end
      else
        end_date = params[:end].to_time().at_end_of_day
      end
      @records = current_user.records.where(date: start_date..end_date).not_delete.order(:date)
      records_json =  @records.as_json(:platform => :web)
      records_json.each do |record|
        record['record_category']['photo_path'] = view_context.asset_path(record['record_category']['photo_path'])
      end
      render :json => {records: records_json, currencyCode: current_user.get_main_currency.currency_code}
    else
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
          @records = @records.sort { |x, y| x.category_order_num <=> y.category_order_num }
        elsif params[:sort] == "category" && params[:direction] == "desc"
          @records = @records.sort { |x, y| y.category_order_num <=> x.category_order_num }
        end
      else
        redirect_to start_use_path
      end
    end
  end

  def destroy
    record = Record.find(params[:id])
    record.is_delete = true
    record.device_uuid = "computer"
    record.update_time = DateTime.now.utc

    if record.save
      @array = params[:delete_type]
      flash["success"] = t('record.delete')

      if !@array.blank? && (@array == "calendar")
        redirect_to calendar_path
       else 
        redirect_to records_path(month_from_now: params[:month_from_now])
      end

    end
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
    params.require(:record).permit(:mount, :date, :in_payment, :out_payment, :payee, :project, :category, :subcategory, :remark, :in_amount, :out_amount, :fee)
  end

  def set_record_submit_value(record)
    record.mount = 0 unless record.mount
    # ===expense===
    if (record.out_payment && !record.in_payment)
      #out_payment_name = record.out_payment.split('(')[0]          # get hash_key from select form directly
      payment = Payment.find_by(hash_key: record.out_payment, user_id: current_user.id)
      #record.out_payment = payment.hash_key                        # get hash_key from select form directly
      init_record = Record.find_by(in_payment: payment.hash_key, category: "SYSTEM", subcategory: "INIT_AMOUNT", user_id: current_user.id)
      record.currency_code = (init_record) ? init_record.currency_code : current_user.get_main_currency.currency_code
      record.amount_to_main = record.calculate_record_amount(current_user.get_main_currency)

      if record.currency_code != record.record_out_payment.display_currency_code(current_user)
        record.out_currency = record.record_out_payment.display_currency_code(current_user)
        record.out_amount = record.calculate_record_amount(Currency.find_by(currency_code: record.record_out_payment.display_currency_code(current_user), user_id: current_user.id))
      end
    end
    # ===income===
    if (!record.out_payment && record.in_payment)
      #in_payment_name = record.in_payment.split('(')[0]          # get hash_key from select form directly
      payment = Payment.find_by(hash_key: record.in_payment, user_id: current_user.id)
      init_record = Record.find_by(in_payment: payment.hash_key, category: "SYSTEM", subcategory: "INIT_AMOUNT", user_id: current_user.id)
      record.currency_code = (init_record) ? init_record.currency_code : current_user.get_main_currency.currency_code
      record.amount_to_main = record.calculate_record_amount(current_user.get_main_currency)

      if record.currency_code != record.record_in_payment.display_currency_code(current_user)
        record.in_currency = record.record_in_payment.display_currency_code(current_user)
        record.in_amount = record.calculate_record_amount(Currency.find_by(currency_code: record.record_in_payment.display_currency_code(current_user), user_id: current_user.id))
      end
    end

    # ===transfer===
    if (record.out_payment && record.in_payment)
      payment = Payment.find_by(hash_key: record.out_payment, user_id: current_user.id)
      #record.out_payment = payment.hash_key       # get hash_key from select form directly
      init_record = Record.find_by(in_payment: payment.hash_key, category: "SYSTEM", subcategory: "INIT_AMOUNT", user_id: current_user.id)
      record.currency_code = (init_record) ? init_record.currency_code : current_user.get_main_currency.currency_code
      record.amount_to_main = record.calculate_record_amount(current_user.get_main_currency)

      if record.currency_code != record.record_out_payment.display_currency_code(current_user)
        record.out_currency = record.record_out_payment.display_currency_code(current_user)
        record.out_amount = record.calculate_record_amount(Currency.find_by(currency_code: record.record_out_payment.display_currency_code(current_user), user_id: current_user.id))
      end

      record.in_currency = record.record_in_payment.display_currency_code(current_user)
      record.in_amount = record.calculate_record_amount(Currency.find_by(currency_code: record.record_in_payment.display_currency_code(current_user), user_id: current_user.id))
    end
    # get hash_key from select form directly and skip find hash_key base on name.
    #record.project = Project.find_by(project_name: record.project, user_id: current_user.id).hash_key 
    #record.payee = Payee.find_by(payee_name: record.payee, user_id: current_user.id).hash_key if record.payee.present?

    record.device_uuid = "computer"
    record.update_time = DateTime.now.utc
  end

  def fetch_variables_for_records
    @expense_category = Category.where(user_id: current_user.id, type: 20).not_hidden.order(:order_no)
    @income_category = Category.where(user_id: current_user.id, type: 10).where.not(hash_key: "SYSTEM").not_hidden.order(:order_no)
    @transfer_category = Category.where(user_id: current_user.id, type: 30).not_hidden.order(:order_no)
    @payments = Payment.where(user_id: current_user.id).not_hidden.order(:order_no)
    @payees = Payee.where(user_id: current_user.id).not_hidden.order(:order_no)
    @projects = Project.where(user_id: current_user.id).not_hidden.order(:order_no)
  end
end
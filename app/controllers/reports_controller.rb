class ReportsController < ApplicationController
  layout 'account'

  before_action :require_user

  def index
     @payments = current_user.payments
     @projects = current_user.projects
     @payees   = current_user.payees
     @expense_categories = Category.where(type: 20, user_id: current_user.id).not_hidden
  end

  def create
    params[:month_from_now] = "0" unless params[:month_from_now]

    payments = []
    categories = []
    projects = []
    payees =[]

    params[:payment].select{|key,val| val == "1"}.each{|key,val| payments << key} if params[:payment]
    params[:category].select{|key,val| val == "1"}.each{|key,val| categories << key} if params[:category]
    params[:project].select{|key,val| val == "1"}.each{|key,val| projects << key} if params[:project]
    params[:payee].select{|key,val| val == "1"}.each{|key,val| payees << key} if params[:payee]

    # expense income trends
    month_days = Time.days_in_month((Time.now + params[:month_from_now].to_i.month).month)
    @expense_trends = Array.new(month_days,0)
    a = Record.month_from_now(params[:month_from_now].to_i).where("out_payment is not null and in_payment is null and user_id = #{current_user.id}").group("DATE(date)").sum(:amount_to_main)
    a.each do |date, val|
      @expense_trends[date.strftime("%d").to_i-1] = val.to_f
    end

    @income_trends = Array.new(month_days,0)
    a = Record.month_from_now(params[:month_from_now].to_i).where("out_payment is null and in_payment is not null and user_id = #{current_user.id}").group("DATE(date)").sum(:amount_to_main)
    a.each do |date, val|
      @income_trends[date.strftime("%d").to_i-1] = val.to_f
    end

    @trends_array = [[t('report.date'), t('record_type.expense'), t('record_type.income')]]
    @expense_trends.each_with_index do |val, index|
      array = []
      array << ((Time.now + params[:month_from_now].to_i.month).beginning_of_month + index.day).strftime("%m/%d")
      array << val
      if @income_trends[index]
        array << @income_trends[index]
      else
        array << 0
      end

      @trends_array << array
    end

    colors = ['#FA363F', '#A4C22B', '#319AA9', '#FD8710', '#F353AF', '#3489D2' , '#FECB0A', '#7D68AC', '#1BA3AC' , '#c1c1c1']
    color_index = 0
    
    case params[:report][:type]
    when "payment"
      payments = Payment.where(hash_key: payments, user_id: current_user.id).sort_by{|p| -p.balance.abs}

      @chart_array = [[t('account.account'), t('total'), { role: "style" }]]
      @pie_array = [[t('account.account'), t('balance')]]

      other_array = []
      other_array << t('other')
      other_balance = 0

      payments.each_with_index do |payment, index|

        array = []
        balance = payment.balance.to_f
        if balance > 0
          array << payment.payment_name
        else
          array << payment.payment_name + "(負)"
        end
        array << balance.abs

        if @chart_array.size < 10
          @pie_array << array.dup
          array << colors[index + color_index]
          @chart_array << array
        else
          other_balance += balance
        end
      end
      other_array << other_balance.abs
      if @chart_array.size == 10
        @pie_array << other_array.dup
        other_array << colors[0]
        @chart_array << other_array
      end
    when "project"
      @chart_array = [[t('payee.payee'), t('total'), { role: "style" }]]
      @pie_array = [[t('payee.payee'), t('total')]]
      payee_amount = Record.month_from_now(params[:month_from_now].to_i).where("user_id = #{current_user.id}").group(:project).sum(:amount_to_main)
      payee_amount = payee_amount.sort_by{|key,val| val}

      other_array = []
      other_array << t('other')
      other_amount = 0

      payee_amount.each_with_index do |hash, index|
        hash_key = hash[0]
        amount = hash[1]

        if payees.include? hash_key
          array = []
          array << Project.find_by(hash_key: hash_key, user_id: current_user.id).project_name
          array << amount.to_f
          
          if @chart_array.size < 10
            @pie_array << array.dup
            array << colors[index + color_index]
            @chart_array << array
          else
            other_amount += amount.to_f
          end
        else
          color_index -= 1
        end
      end
      other_array << other_amount
      if @chart_array.size == 10
        @pie_array << other_array.dup
        other_array << colors[0]
        @chart_array << other_array
      end 
      # @chart_array = [[t('project.project'), t('total')]]
      # @pie_array = [[t('project.project'), t('total')]]
      # project_amount = Record.month_from_now(params[:month_from_now].to_i).where("user_id = #{current_user.id}").group(:project).sum(:amount_to_main)
      # project_amount = project_amount.sort_by{|key,val| val}

      # other_array = []
      # other_array << t('other')
      # other_amount = 0

      # project_amount.each_with_index do |hash, index|
      #   hash_key = hash[0]
      #   amount = hash[1]
      #   if projects.include? hash_key
      #     array = []
      #     array << Project.find_by(hash_key: hash_key, user_id: current_user.id).project_name
      #     array << amount.to_f

      #     if @chart_array.size < 10
      #       @pie_array << array.dup
      #       array << colors[index + color_index]
      #       @chart_array << array
      #     else
      #       other_amount += amount.to_f
      #     end
      #   else
      #     color_index -= 1
      #   end
      # end
      # other_array << other_amount
      # if @chart_array.size == 10
      #   @pie_array << other_array.dup
      #   other_array << colors[0]
      #   @chart_array << other_array
      # end 
    when "payee"
      @chart_array = [[t('payee.payee'), t('total'), { role: "style" }]]
      @pie_array = [[t('payee.payee'), t('total')]]
      payee_amount = Record.month_from_now(params[:month_from_now].to_i).where("user_id = #{current_user.id}").group(:payee).sum(:amount_to_main)
      payee_amount = payee_amount.sort_by{|key,val| val}

      other_array = []
      other_array << t('other')
      other_amount = 0

      payee_amount.each_with_index do |hash, index|
        hash_key = hash[0]
        amount = hash[1]

        if payees.include? hash_key
          array = []
          array << Payee.find_by(hash_key: hash_key, user_id: current_user.id).payee_name
          array << amount.to_f
          
          if @chart_array.size < 10
            @pie_array << array.dup
            array << colors[index + color_index]
            @chart_array << array
          else
            other_amount += amount.to_f
          end
        else
          color_index -= 1
        end
      end
      other_array << other_amount
      if @chart_array.size == 10
        @pie_array << other_array.dup
        other_array << colors[0]
        @chart_array << other_array
      end 
    when "category"      
      @chart_array = [[t('category.category'), t('total'), { role: "style" }]]
      @pie_array = [[t('category.category'), t('total')]]

      category_amount = Record.month_from_now(params[:month_from_now].to_i).where("user_id = #{current_user.id}").group(:category).sum(:amount_to_main)
      category_amount = category_amount.sort_by{|key,val| val}

      other_array = []
      other_array << t('other')
      other_amount = 0

      category_amount.each_with_index do |hash, index|
        hash_key = hash[0]
        amount = hash[1]

        if categories.include? hash_key
          array = []
          array << Category.find_by(hash_key: hash_key, user_id: current_user.id).category
          array << amount.to_f

          if @chart_array.size < 10
            @pie_array << array.dup
            array << colors[index + color_index]
            @chart_array << array
          else
            other_amount += amount.to_f
          end
        else
          color_index -= 1
        end
      end
      
      other_array << other_amount
      
      if @chart_array.size == 10
        @pie_array << other_array.dup
        other_array << colors[0]
        @chart_array << other_array
      end 

      
      # logger.debug "trend*************************************************************************************************************************************************************************************************************fail dddddddddddddddd****************" 
      # logger.debug @trends_array.inspect
      # logger.debug "pie**************************************************************************************************************************************************************************************************************fail dddddddddddddddd****************" 
      # logger.debug @pie_array.inspect
      # logger.debug "chart**************************************************************************************************************************************************************************************************************fail dddddddddddddddd****************" 
      # logger.debug @chart_array.inspect
      # logger.debug "other**************************************************************************************************************************************************************************************************************fail dddddddddddddddd****************" 
      # logger.debug @other_array.inspect
      # logger.debug "111111**************************************************************************************************************************************************************************************************************fail dddddddddddddddd****************" 

      
    end

  end

  def expense_category
    @expense_categories = Category.where(type: 20, user_id: current_user.id).not_hidden
  end

  def income_category
    @income_categories = Category.where("type = 10 and hash_key != 'SYSTEM' and user_id = #{current_user.id}").not_hidden
  end
end
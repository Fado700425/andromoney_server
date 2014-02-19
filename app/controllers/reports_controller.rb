class ReportsController < ApplicationController

  layout 'account'

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

    params[:payment].select{|key,val| val == "1"}.each{|key,val| payments << key}
    params[:category].select{|key,val| val == "1"}.each{|key,val| categories << key}
    params[:project].select{|key,val| val == "1"}.each{|key,val| projects << key}
    params[:payee].select{|key,val| val == "1"}.each{|key,val| payees << key}

    # expense income trends
    @expense_trends = Array.new(Time.days_in_month((Time.now + params[:month_from_now].to_i.month).month),0)
    a = Record.month_from_now(params[:month_from_now].to_i).where("out_payment is not null and in_payment is null and user_id = #{current_user.id}").group(:date).sum(:amount_to_main)
    a.each do |date, val|
      @expense_trends[date.strftime("%d").to_i-1] = val.to_f
    end

    @income_trends = Array.new(Time.days_in_month((Time.now + params[:month_from_now].to_i.month).month),0)
    a = Record.month_from_now(params[:month_from_now].to_i).where("out_payment is null and in_payment is not null and user_id = #{current_user.id}").group(:date).sum(:amount_to_main)
    a.each do |date, val|
      @income_trends[date.strftime("%d").to_i-1] = val.to_f
    end

    @trends_array = [['日期', '支出', '收入']]
    @expense_trends.each_with_index do |val, index|
      array = []
      array << ((Time.now + params[:month_from_now].to_i.month).beginning_of_month + index.day).strftime("%m/%d")
      array << val
      array << @income_trends[index]

      @trends_array << array
    end

    colors = ['#fecb0a', '#a3c22b', '#319aa8', '#fd8711', '#fa373f', '#f351af' , '#358ad3', '#fa373f', '#f351af' , '#358ad3']
    color_index = 0

    case params[:report][:type]
    when "payment"
      payments = Payment.where(hash_key: payments).sort_by{|p| -p.balance.abs}

      @chart_array = [['專案', '總計', { role: "style" }]]
      @pie_array = [['帳戶', '結餘']]

      other_array = []
      other_array << '其它'
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
      @chart_array = [['專案', '總計']]
      project_amount = Record.month_from_now(params[:month_from_now].to_i).where("user_id = #{current_user.id}").group(:project).sum(:amount_to_main)
      project_amount = project_amount.sort_by{|key,val| val}

      other_array = []
      other_array << '其它'
      other_amount = 0

      project_amount.each do |hash_key, amount|
        if projects.include? hash_key
          array = []
          array << Project.find_by(hash_key: hash_key).category
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
    when "payee"
      @chart_array = [['專案', '總計', { role: "style" }]]
      @pie_array = [['專案', '總計']]
      payee_amount = Record.month_from_now(params[:month_from_now].to_i).where("user_id = #{current_user.id}").group(:payee).sum(:amount_to_main)
      payee_amount = payee_amount.sort_by{|key,val| val}

      other_array = []
      other_array << '其它'
      other_amount = 0

      payee_amount.each_with_index do |hash_key, index|
        hash_key = hash[0]
        amount = hash[1]

        if payees.include? hash_key
          array = []
          array << Payee.find_by(hash_key: hash_key).category
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
      @chart_array = [['類別', '總計', { role: "style" }]]
      @pie_array = [['類別', '總計']]
      category_amount = Record.month_from_now(params[:month_from_now].to_i).where("user_id = #{current_user.id}").group(:category).sum(:amount_to_main)
      category_amount = category_amount.sort_by{|key,val| val}

      other_array = []
      other_array << '其它'
      other_amount = 0

      category_amount.each_with_index do |hash, index|
        hash_key = hash[0]
        amount = hash[1]

        if categories.include? hash_key
          array = []
          array << Category.find_by(hash_key: hash_key).category
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
    end

  end

  def expense_category
    @expense_categories = Category.where(type: 20, user_id: current_user.id).not_hidden
  end

  def income_category
    @income_categories = Category.where("type = 10 and hash_key != 'SYSTEM' and user_id = #{current_user.id}").not_hidden
  end
end
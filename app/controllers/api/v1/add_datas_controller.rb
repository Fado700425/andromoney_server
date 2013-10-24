class Api::V1::AddDatasController < ApplicationController
  skip_before_filter  :verify_authenticity_token
  
  def create
    Rails.logger.info("PARAMS: #{params.inspect}")
    
    unless params[:body]
      render :status=>404, :json=>{:message=>"Create Fail"}
      return
    end
    
    body_params = JSON.parse(params[:body],:symbolize_names => true)
    user = User.find_by(email: body_params[:user])
    if user
      create_all_data(user,body_params)
      render :status=>200, :json=>{:message=>"Create Success"}
    else
      render :status=>404, :json=>{:message=>"Create Fail"}
    end
  end

  private

  def create_all_data(user,params)
    
    if params[:records]
      params[:records].each do |record_param|
        record = Record.new(record_param)
        record.user = user
        record.save
      end
    end

    if params[:categories]
      params[:categories].each do |cat_param|
        category = Category.new(cat_param)
        category.user = user
        category.save
      end
    end

    if params[:payees]
      params[:payees].each do |payee_param|
        payee = Payee.new(payee_param)
        payee.user = user
        payee.save
      end
    end

    if params[:currencies]
      params[:currencies].each do |currency_param|
        currency = Currency.new(currency_param)
        currency.user = user
        currency.save
      end
    end

    if params[:payments]
      params[:payments].each do |payment_param|
        payment = Payment.new(payment_param)
        payment.user = user
        payment.save
      end
    end

    if params[:periods]
      params[:periods].each do |period_param|
        period = Period.new(period_param)
        period.user = user
        period.save
      end
    end

    if params[:prefs]
      params[:prefs].each do |pref_param|
        pref = Pref.new(pref_param)
        pref.user = user
        pref.save
      end
    end

    if params[:projects]
      params[:projects].each do |project_param|
        project = Project.new(project_param)
        project.user = user
        project.save
      end
    end

    if params[:subcategories]
      params[:subcategories].each do |subcategory_param|
        subcategory = Subcategory.new(subcategory_param)
        subcategory.user = user
        subcategory.save
      end
    end

  end
end
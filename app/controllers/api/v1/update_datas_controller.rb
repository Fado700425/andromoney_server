class Api::V1::UpdateDatasController < ApplicationController
  skip_before_filter  :verify_authenticity_token
  
  def update_all
    user = User.find_by(email: params[:id])
    if user
      update_all_data(user,params)
      render :status=>200, :json=>{:message=>"Update Success"}
    else
      render :status=>404, :json=>{:message=>"Update Fail"}
    end
  end

  private

  def update_all_data(user,params)
    if params[:records]
      params[:records].each do |record_param|
        record = Record.find_by(hash_key: record_param[:hash_key], user_id: user.id)
        record.update_attributes(record_param) if record
      end
    end
    if params[:categories]
      params[:categories].each do |cat_param|
        cat = Category.find_by(hash_key: cat_param[:hash_key], user_id: user.id)
        cat.update_attributes(cat_param) if cat
      end
    end
    if params[:payees]
      params[:payees].each do |payee_param|
        payee = Payee.find_by(hash_key: payee_param[:hash_key], user_id: user.id)
        payee.update_attributes(payee_param) if payee
      end
    end
    if params[:currencies]
      params[:currencies].each do |currency_param|
        currency = Currency.find_by(currency_code: currency_param[:currency_code], user_id: user.id)
        currency.update_attributes(currency_param) if currency
      end
    end
    if params[:payments]
      params[:payments].each do |payment_param|
        payment = Payment.find_by(hash_key: payment_param[:hash_key], user_id: user.id)
        payment.update_attributes(payment_param) if payment
      end
    end
    if params[:periods]
      params[:periods].each do |period_param|
        period = Period.find_by(hash_key: period_param[:hash_key], user_id: user.id)
        period.update_attributes(period_param) if period
      end
    end
    if params[:prefs]
      params[:prefs].each do |pref_param|
        pref = Pref.find_by(key: pref_param[:key], user_id: user.id)
        pref.update_attributes(pref_param) if pref
      end
    end
    if params[:projects]
      params[:projects].each do |project_param|
        project = Project.find_by(hash_key: project_param[:hash_key], user_id: user.id)
        project.update_attributes(project_param) if project
      end
    end
    if params[:subcategories]
      params[:subcategories].each do |subcategory_param|
        subcategory = Subcategory.find_by(hash_key: subcategory_param[:hash_key], user_id: user.id)
        subcategory.update_attributes(subcategory_param) if subcategory
      end
    end
  end
end
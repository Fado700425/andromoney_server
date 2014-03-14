class UpgradeController < AccountController

  layout 'api', only: [:mobile]
  
  def create
    payment_process params
  end

  def index
  end

  def mobile
  end

  def mobile_pay


    current_user = User.find_by(email: params[:user])
    if current_user
      payment_process(params)
    else
      redirect_to mobile_upgrade_index_path(params)
    end

  end

private

  def payment_process params
    price = { "en" => [99, 999, 1499, 999], "zh" => [3000, 30000, 45000, 30000], "zh-TW" => [3000, 30000, 45000, 30000] }
    currency_code = { "en" => "usd", "zh" => "twd", "zh-TW" => "twd"}

    case params[:optionsRadios]
    when "no_expire"
      if params[:is_mobile_pro] == "true"
        amount = price[params[:locale]][3]
      else
        amount = price[params[:locale]][2]
      end
    when "year"
      amount = price[params[:locale]][1]
    when "month"
      amount = price[params[:locale]][0]
    end

    charge = Stripe::Charge.create(
      :amount => amount, # amount in cents, again
      :currency => currency_code[params[:locale]],
      :card => params[:stripeToken],
      :description => "Sign Up Charge for"
    )

    current_user.is_pro = true

    case params[:optionsRadios]
    when "no_expire"
      current_user.expire_date = Time.now + 30000.days
    when "year"
      current_user.expire_date = Time.now + 365.days
    when "month"
      current_user.expire_date = Time.now + 31.days
    end
    current_user.save
  end 
end
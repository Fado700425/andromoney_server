class UpgradeController < ApplicationController

  layout 'account'

  def create

    charge = Stripe::Charge.create(
      :amount => 2000, # amount in cents, again
      :currency => "usd",
      :card => params[:stripeToken],
      :description => "Sign Up Charge for"
    )

    current_user.is_pro = true
    current_user.expire_date = Time.now + 30000.days
    current_user.save
  end

  def index
  end

end
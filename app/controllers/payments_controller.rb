class PaymentsController < ApplicationController

  layout 'account'

  def index
    @payments = Payment.where(user_id: current_user.id)
  end

end
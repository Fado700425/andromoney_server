class BudgetsController < ApplicationController

  layout 'account'

  def index
    @expense_category = Category.where(type: 20, user_id: current_user.id)
  end

end
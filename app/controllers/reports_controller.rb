class ReportsController < ApplicationController

  layout 'account'

  def index
    @payments = current_user.payments
    @projects = current_user.projects
    @payees   = current_user.payees
    @expense_categories = Category.where(type: 20, user_id: current_user.id).not_hidden
  end

  def expense_category
    @expense_categories = Category.where(type: 20, user_id: current_user.id).not_hidden
  end

  def income_category
    @income_categories = Category.where("type = 10 and hash_key != 'SYSTEM' and user_id = #{current_user.id}").not_hidden
  end
end
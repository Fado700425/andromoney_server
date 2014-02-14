class ReportsController < ApplicationController

  layout 'account'

  def index
    @payments = current_user.payments
    @projects = current_user.projects
    @payees   = current_user.payees
    @expense_categories = Category.where(type: 20, user_id: current_user.id).not_hidden
  end

  def create
    payments = []
    categories = []
    projects = []
    payees =[]

    params[:payment].select{|key,val| val == "1"}.each{|key,val| payments << key}
    params[:category].select{|key,val| val == "1"}.each{|key,val| categories << key}
    params[:project].select{|key,val| val == "1"}.each{|key,val| projects << key}
    params[:payee].select{|key,val| val == "1"}.each{|key,val| payees << key}
    binding.pry
  end

  def expense_category
    @expense_categories = Category.where(type: 20, user_id: current_user.id).not_hidden
  end

  def income_category
    @income_categories = Category.where("type = 10 and hash_key != 'SYSTEM' and user_id = #{current_user.id}").not_hidden
  end
end
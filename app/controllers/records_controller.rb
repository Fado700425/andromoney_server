class RecordsController < ApplicationController

  layout 'account'

  def new
    @record = Record.new
    @expense_category = Category.where(type: 20, user_id: current_user.id).each_slice(3).to_a
    @income_category = Category.where("type = 10 and hash_key != 'SYSTEM' and user_id = #{current_user.id}").each_slice(3).to_a
    @payments = Payment.where(user_id: current_user.id).each_slice(3).to_a
    @payees = Payee.where(user_id: current_user.id).each_slice(3).to_a
    @projects = Project.where(user_id: current_user.id).each_slice(3).to_a
    @subcategories = Subcategory.where(id_category: @expense_category.first[0].hash_key, user_id: current_user.id).each_slice(3).to_a
    @income_subcategories = Subcategory.where(id_category: @income_category.first[0].hash_key, user_id: current_user.id).each_slice(3).to_a
  end

  def create
    @record = Record.new(record_param)
    @record.out_payment = Payment.find_by(payment_name: @record.out_payment).hash_key if @record.out_payment
    @record.in_payment = Payment.find_by(payment_name: @record.in_payment).hash_key if @record.in_payment
    @record.project = Project.find_by(project_name: @record.project).hash_key if @record.project.present?
    @record.payee = Payee.find_by(payee_name: @record.payee).hash_key if @record.payee.present?
    @record.hash_key = SecureRandom.urlsafe_base64
    @record.user_id = current_user.id
    if @record.save
      flash[:notice] = "Create success"      
    else
      flash[:error] = "Create fail!"
    end
    redirect_to records_path(month_from_now: params[:month_from_now])
  end

  def index
    
    if params[:month_from_now]
      @records = current_user.records.month_from_now(params[:month_from_now].to_i)
    else
      @records = current_user.records.month_from_now(0)
    end

  end

  def edit_remark
    record = Record.find_by(user_id: current_user.id, id: params[:record_id])
    if record
      record.remark = params[:remark]
      record.save
    end
    redirect_to records_path(month_from_now: params[:month_from_now])
  end

  def destroy
    Record.delete(params[:id])
    flash[:notice] = "delete success"
    redirect_to records_path(month_from_now: params[:month_from_now])
  end

private
  def record_param
    params.require(:record).permit(:mount,:date,:in_payment,:out_payment,:payee,:project,:category,:sub_category,:remark)
  end
end
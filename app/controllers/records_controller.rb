class RecordsController < ApplicationController

  layout 'account'

  def new
    @record = Record.new
  end

  def create
    @record = Record.new(record_param)
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
    params.require(:news).permit(:title,:content,:pic,:sort,:sort_en,:is_tw,:is_en,:release_date)
  end
end
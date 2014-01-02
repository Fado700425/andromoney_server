class RecordsController < ApplicationController

  layout 'account'

  def new
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
end
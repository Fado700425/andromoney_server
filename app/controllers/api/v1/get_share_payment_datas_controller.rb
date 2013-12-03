class Api::V1::GetSharePaymentDatasController < ApplicationController
  def index
    owner = User.find_by(email: params[:owner_user])
    per_page = (params[:per_page])? (params[:per_page]) : 500

    if owner
      relation = UserSharePaymentRelation.find_by(owner_user_id: owner.id, payment_hash_key: params[:payment_hash_key])
      data = relation.payment.payment_related_datas(owner.id, params[:sync_time], params[:page], per_page)
      render :status=>200, :json=> data.to_json
    else
      render :status=>404, :json=>{:message=>"get Fail"}
    end
  end

  def users_who_shared_by_owner
    user = User.find_by(email: params[:owner_user])

    if user && params[:payment_hash_key]
      relations = UserSharePaymentRelation.joins(:share).where(owner_user_id: user.id, payment_hash_key: params[:payment_hash_key]).select("users.id,users.email, user_share_payment_relations.is_approved")
      render :status=>200, :json=> relations
    else
      render :status=>404, :json=>{:message=>"get Fail"}
    end
  end

  def payments_shared_by_others
    user = User.find_by(email: params[:user])
    if user
      relations = UserSharePaymentRelation.where(share_user_id: user.id).map{|relation| "(payment_table.user_id = '#{relation.owner_user_id}' and payment_table.hash_key = '#{relation.payment_hash_key}')"}
      payments = Payment.joins(:user).where(relations.join(" or ")).select("payment_table.id,users.email, payment_table.kind, payment_table.payment_name, total, currency_code,rate, out_total, hidden, order_no, hash_key,payment_table.update_time ")
      render :status=>200, :json=> payments
    else
      render :status=>404, :json=>{:message=>"get Fail"}
    end
  end
end
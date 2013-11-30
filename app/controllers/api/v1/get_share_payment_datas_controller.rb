class Api::V1::GetSharePaymentDatasController < ApplicationController
  def index
    user = User.find_by(email: params[:user])

    if user
      relations = UserSharePaymentRelation.where("share_user_id = ?", user.id)
      datas = {}
      relations.each do |relation|
        owner = relation.owner
        datas[owner.email] = relation.payment.payment_related_datas(owner.id)
      end
      render :status=>200, :json=> datas.to_json
    else
      render :status=>404, :json=>{:message=>"get Fail"}
    end
  end

  def users_who_shared_by_owner
    user = User.find_by(email: params[:owner_user])

    if user && params[:payment_hash_key]
      relations = UserSharePaymentRelation.joins(:share).where("owner_user_id is ? and payment_hash_key is ?", user.id, params[:payment_hash_key]).select("users.id,users.email")
      render :status=>200, :json=> relations
    else
      render :status=>404, :json=>{:message=>"get Fail"}
    end
  end
end
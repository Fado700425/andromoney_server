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
end
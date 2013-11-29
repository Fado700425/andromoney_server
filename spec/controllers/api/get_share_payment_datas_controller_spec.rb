require 'spec_helper'

describe Api::V1::GetSharePaymentDatasController do
  describe "get Index" do
    
    context "with valid user data" do
      it "return all user being shared datas" do
        bob = Fabricate(:user)
        john = Fabricate(:user)
        share_payment = Fabricate(:payment, user_id: bob.id)
        Fabricate(:user_share_payment_relation, share_user_id: john.id, owner_user_id: bob.id, payment_hash_key: share_payment.hash_key, token: SecureRandom.urlsafe_base64)
        Fabricate(:record, in_payment: share_payment.hash_key, user_id: bob.id)
        get :index, {user: john.email}
        body = ActiveSupport::JSON.decode(response.body)
        expect(body).to be_present
      end
    end

    context "with invalid user data" do
      it "return status 404" do
        get :index
        response.response_code.should == 404
      end
    end
  end

end
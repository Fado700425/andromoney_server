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

  describe "Get users_who_shared_by_owner" do

    it "return all user shared payments which is approved" do
      bob = Fabricate(:user)
      john = Fabricate(:user)
      share_payment = Fabricate(:payment, user_id: bob.id)
      relation = Fabricate(:user_share_payment_relation, share_user_id: john.id, owner_user_id: bob.id, payment_hash_key: share_payment.hash_key, token: SecureRandom.urlsafe_base64, is_approved: true)
      get :users_who_shared_by_owner, {owner_user: bob.email, payment_hash_key: share_payment.hash_key}
      body = ActiveSupport::JSON.decode(response.body)
      expect(body.size).to eq(1)
    end

    it "don't return all user shared payments which is not approved" do
      bob = Fabricate(:user)
      john = Fabricate(:user)
      share_payment = Fabricate(:payment, user_id: bob.id)
      relation = Fabricate(:user_share_payment_relation, share_user_id: john.id, owner_user_id: bob.id, payment_hash_key: share_payment.hash_key, token: SecureRandom.urlsafe_base64)
      get :users_who_shared_by_owner, {owner_user: bob.email, payment_hash_key: share_payment.hash_key}
      body = ActiveSupport::JSON.decode(response.body)
      expect(body.size).to eq(0)
    end

    context "with invalid user data" do
      it "return status 404" do
        get :users_who_shared_by_owner
        response.response_code.should == 404
      end
    end
    
  end

end
require 'spec_helper'

describe Api::V1::SyncController do

  describe "Post start" do
    
    context "with valid inputs" do
      it "return start_sync_time" do
        user = Fabricate(:user, is_syncing: true, sync_time: Time.now - 1.hour)
        device1 = Fabricate(:device, user_id: user.id)
        post :start, {body: {user: user.email,device: device1.uuid}}
        response.response_code.should == 200
      end
    end

    context "with invalid inputs" do
      it "return status 404" do
        post :start, {body: {user: "test",device: "fake_id"}}
        response.response_code.should == 404
      end
    end
  end

  describe "Post end" do
    it "update the device last_sync_time" do
      user = Fabricate(:user, is_syncing: true)
      device = Fabricate(:device, user_id: user.id, is_syncing: true)
      sync_time = Time.now.utc
      post :end, {body: {user: user.email,device: device.uuid, sync_time: sync_time}}
      device.reload.last_sync_time.utc.to_i.should == sync_time.to_i
    end
  end


  describe "Post owner_share_user_payment" do
    context "with valid input" do
      it "add sync payment request to data" do
        bob = Fabricate(:user)
        john = Fabricate(:user)
        share_payment = Fabricate(:payment, user_id: bob.id)
        post :owner_share_user_payment, {body: {owner_user: bob.email, share_user: john.email, payment_hash_key: share_payment.hash_key}}
        expect(UserSharePaymentRelation.count).to eq(1)
      end
      it "do not add sync payment request to data if already have the data" do
        bob = Fabricate(:user)
        john = Fabricate(:user)
        share_payment = Fabricate(:payment, user_id: bob.id)
        post :owner_share_user_payment, {body: {owner_user: bob.email, share_user: john.email, payment_hash_key: share_payment.hash_key}}
        post :owner_share_user_payment, {body: {owner_user: bob.email, share_user: john.email, payment_hash_key: share_payment.hash_key}}
        expect(UserSharePaymentRelation.count).to eq(1)
      end
      it "sync request should not be approved" do
        bob = Fabricate(:user)
        john = Fabricate(:user)
        share_payment = Fabricate(:payment, user_id: bob.id)
        post :owner_share_user_payment, {body: {owner_user: bob.email, share_user: john.email, payment_hash_key: share_payment.hash_key}}
        expect(UserSharePaymentRelation.first.is_approved).to be_false
      end
      it "sync request should have unique invite token" do
        bob = Fabricate(:user)
        john = Fabricate(:user)
        share_payment = Fabricate(:payment, user_id: bob.id)
        post :owner_share_user_payment, {body: {owner_user: bob.email, share_user: john.email, payment_hash_key: share_payment.hash_key}}
        expect(UserSharePaymentRelation.first.token).to be_present
      end
      it "send out sync payment request email to user" do
        ActionMailer::Base.deliveries.clear
        bob = Fabricate(:user)
        john = Fabricate(:user)
        share_payment = Fabricate(:payment, user_id: bob.id)
        post :owner_share_user_payment, {body: {owner_user: bob.email, share_user: john.email, payment_hash_key: share_payment.hash_key}}
        ActionMailer::Base.deliveries.should_not be_empty
      end

      it "send out sync payment request email to share user who not register" do
        ActionMailer::Base.deliveries.clear
        bob = Fabricate(:user)
        share_payment = Fabricate(:payment, user_id: bob.id)
        post :owner_share_user_payment, {body: {owner_user: bob.email, share_user: "test@gmail.com", payment_hash_key: share_payment.hash_key}}
        ActionMailer::Base.deliveries.should_not be_empty
      end
    end
    context "with invalid input" do
      it "render error message" do
        bob = Fabricate(:user)
        john = Fabricate(:user)
        share_payment = Fabricate(:payment)
        post :owner_share_user_payment, {body: {owner_user: bob.email, share_user: john.email, payment_hash_key: share_payment.hash_key}}
        response.response_code.should == 404
      end
    end
  end

  describe "Delete delete_share" do
    it "post the share relation" do
      bob = Fabricate(:user)
      john = Fabricate(:user)
      share_payment = Fabricate(:payment, user_id: bob.id)
      Fabricate(:user_share_payment_relation, share_user_id: john.id, owner_user_id: bob.id, payment_hash_key: share_payment.hash_key, token: SecureRandom.urlsafe_base64)
      post :delete_share, {body: {owner_user: bob.email, share_user: john.email, payment_hash_key: share_payment.hash_key, locale: "en"}}
      expect(UserSharePaymentRelation.count).to eq(0)
    end
    it "send email to share user and owner user" do
      ActionMailer::Base.deliveries.clear
      bob = Fabricate(:user)
      john = Fabricate(:user)
      share_payment = Fabricate(:payment, user_id: bob.id)
      Fabricate(:user_share_payment_relation, share_user_id: john.id, owner_user_id: bob.id, payment_hash_key: share_payment.hash_key, token: SecureRandom.urlsafe_base64)
      post :delete_share, {body: {owner_user: bob.email, share_user: john.email, payment_hash_key: share_payment.hash_key, locale: "en"}}
      ActionMailer::Base.deliveries.should_not be_empty
    end
  end

  describe "Get confirm_share" do
    it "set the approved the share relation" do
      bob = Fabricate(:user)
      john = Fabricate(:user)
      share_payment = Fabricate(:payment, user_id: bob.id)
      relation = Fabricate(:user_share_payment_relation, share_user_id: john.id, owner_user_id: bob.id, payment_hash_key: share_payment.hash_key, token: SecureRandom.urlsafe_base64)
      get :confirm_share, token: relation.token
      expect(relation.reload.is_approved).to be_true
    end

    it "return fail if do not find the relation" do
      bob = Fabricate(:user)
      john = Fabricate(:user)
      share_payment = Fabricate(:payment, user_id: bob.id)
      relation = Fabricate(:user_share_payment_relation, share_user_id: john.id, owner_user_id: bob.id, payment_hash_key: share_payment.hash_key, token: SecureRandom.urlsafe_base64)
      get :confirm_share, token: nil
      response.response_code.should == 404
    end
  end

end
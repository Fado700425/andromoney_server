require 'spec_helper'

describe Api::V1::DeleteDatasController do

  describe "Delete destroy" do

    context "with valid input" do

      it "delete the record data" do
        user1 = Fabricate(:user)
        device = Fabricate(:device, user_id: user1.id)
        record1 = Fabricate(:record, user_id: user1.id, update_time: Time.now - 1.hour)
        record2 = Fabricate(:record, user_id: user1.id, update_time: Time.now - 1.hour)
        post :delete_all, body: {user: user1.email, device: device.uuid, record_table: [{hash_key: record1.hash_key, update_time: Time.now},{hash_key: record2.hash_key, update_time: Time.now}]}
        expect(record1.reload.is_delete).to be_true
        expect(record2.reload.is_delete).to be_true
      end

      it "set the deleted record data device uuid" do
        user1 = Fabricate(:user)
        device = Fabricate(:device, user_id: user1.id)
        record1 = Fabricate(:record, user_id: user1.id, update_time: Time.now - 1.hour)
        record2 = Fabricate(:record, user_id: user1.id, update_time: Time.now - 1.hour)
        post :delete_all, body: {user: user1.email, device: device.uuid, record_table: [{hash_key: record1.hash_key, update_time: Time.now},{hash_key: record2.hash_key, update_time: Time.now}]}
        expect(record1.reload.device_uuid).to eq(device.uuid)
      end

      it "update the delete record data updated_at field" do
        user1 = Fabricate(:user)
        device = Fabricate(:device, user_id: user1.id)
        record1 = Fabricate(:record, user_id: user1.id, updated_at: Time.now - 2.hours, update_time: Time.now - 2.hours)
        post :delete_all, body: {user: user1.email, device: device.uuid, record_table: [{hash_key: record1.hash_key, update_time: Time.now}]}
        
        expect(record1.reload.updated_at > Time.now - 1.hour).to be_true
      end

      it "do not delete the record data which not belong to the user" do
        user1 = Fabricate(:user)
        user2 = Fabricate(:user)
        device = Fabricate(:device, user_id: user1.id)
        record1 = Fabricate(:record, user_id: user1.id, update_time: Time.now - 1.hour)
        record2 = Fabricate(:record, user_id: user2.id, update_time: Time.now - 1.hour)
        post :delete_all, body: {user: user1.email, device: device.uuid, record_table: [{hash_key: record1.hash_key, update_time: Time.now},{hash_key: record2.hash_key, update_time: Time.now}]}
        expect(record1.reload.is_delete).to be_true
        expect(record2.reload.is_delete).to be_false
      end

      it "delete the category data" do
        user1 = Fabricate(:user)
        user2 = Fabricate(:user)
        device = Fabricate(:device, user_id: user1.id)
        category1 = Fabricate(:category, user_id: user1.id, update_time: Time.now - 1.hour)
        category2 = Fabricate(:category, user_id: user2.id, update_time: Time.now - 1.hour)
        post :delete_all, body: {user: user1.email, device: device.uuid, category_table: [{hash_key: category1.hash_key, update_time: Time.now},{hash_key: category2.hash_key, update_time: Time.now}]}
        expect(category1.reload.is_delete).to be_true
        expect(category2.reload.is_delete).to be_false
      end

      it "delete the payee data" do
        user1 = Fabricate(:user)
        user2 = Fabricate(:user)
        device = Fabricate(:device, user_id: user1.id)
        payee1 = Fabricate(:payee, user_id: user1.id, update_time: Time.now - 1.hour)
        payee2 = Fabricate(:payee, user_id: user2.id, update_time: Time.now - 1.hour)
        post :delete_all, body: {user: user1.email, device: device.uuid, payee_table: [{hash_key: payee1.hash_key, update_time: Time.now},{hash_key: payee2.hash_key, update_time: Time.now}]}
        expect(payee1.reload.is_delete).to be_true
        expect(payee2.reload.is_delete).to be_false
      end

      it "delete the currency data" do
        user1 = Fabricate(:user)
        user2 = Fabricate(:user)
        device = Fabricate(:device, user_id: user1.id)
        currency1 = Fabricate(:currency, user_id: user1.id, update_time: Time.now - 1.hour)
        currency2 = Fabricate(:currency, user_id: user2.id, update_time: Time.now - 1.hour)
        post :delete_all, body: {user: user1.email, device: device.uuid, currency_table: [{currency_code: currency1.currency_code, update_time: Time.now},{currency_code: currency2.currency_code, update_time: Time.now}]}
        expect(currency1.reload.is_delete).to be_true
        expect(currency2.reload.is_delete).to be_false
      end

      it "delete the payment data" do
        user1 = Fabricate(:user)
        user2 = Fabricate(:user)
        device = Fabricate(:device, user_id: user1.id)
        payment1 = Fabricate(:payment, user_id: user1.id, update_time: Time.now - 1.hour)
        payment2 = Fabricate(:payment, user_id: user2.id, update_time: Time.now - 1.hour)
        post :delete_all, body: {user: user1.email, device: device.uuid, payment_table: [{hash_key: payment1.hash_key, update_time: Time.now},{hash_key: payment2.hash_key, update_time: Time.now}]}
        expect(payment1.reload.is_delete).to be_true
        expect(payment2.reload.is_delete).to be_false
      end

      it "delete the period data" do
        user1 = Fabricate(:user)
        user2 = Fabricate(:user)
        device = Fabricate(:device, user_id: user1.id)
        period1 = Fabricate(:period, user_id: user1.id, update_time: Time.now - 1.hour)
        period2 = Fabricate(:period, user_id: user2.id, update_time: Time.now - 1.hour)
        post :delete_all, body: {user: user1.email, device: device.uuid, period_table: [{hash_key: period1.hash_key, update_time: Time.now},{hash_key: period2.hash_key, update_time: Time.now}]}
        expect(period1.reload.is_delete).to be_true
        expect(period2.reload.is_delete).to be_false
      end

      it "delete the pref data" do
        user1 = Fabricate(:user)
        user2 = Fabricate(:user)
        device = Fabricate(:device, user_id: user1.id)
        pref1 = Fabricate(:pref, user_id: user1.id, update_time: Time.now - 1.hour)
        pref2 = Fabricate(:pref, user_id: user2.id, update_time: Time.now - 1.hour)
        post :delete_all, body: {user: user1.email, device: device.uuid, pref_table: [{key: pref1.key, update_time: Time.now},{key: pref2.key, update_time: Time.now}]}
        expect(pref1.reload.is_delete).to be_true
        expect(pref2.reload.is_delete).to be_false
      end

      it "delete the project data" do
        user1 = Fabricate(:user)
        user2 = Fabricate(:user)
        device = Fabricate(:device, user_id: user1.id)
        project1 = Fabricate(:project, user_id: user1.id, update_time: Time.now - 1.hour)
        project2 = Fabricate(:project, user_id: user2.id, update_time: Time.now - 1.hour)
        post :delete_all, body: {user: user1.email, device: device.uuid, project_table: [{hash_key: project1.hash_key, update_time: Time.now},{hash_key: project2.hash_key, update_time: Time.now}]}
        expect(project1.reload.is_delete).to be_true
        expect(project2.reload.is_delete).to be_false
      end

      it "delete the subcategory data" do
        user1 = Fabricate(:user)
        user2 = Fabricate(:user)
        device = Fabricate(:device, user_id: user1.id)
        subcategory1 = Fabricate(:subcategory, user_id: user1.id, update_time: Time.now - 1.hour)
        subcategory2 = Fabricate(:subcategory, user_id: user2.id, update_time: Time.now - 1.hour)
        post :delete_all, body: {user: user1.email, device: device.uuid, subcategory_table: [{hash_key: subcategory1.hash_key, update_time: Time.now},{hash_key: subcategory2.hash_key, update_time: Time.now}]}
        expect(subcategory1.reload.is_delete).to be_true
        expect(subcategory2.reload.is_delete).to be_false
      end


      it "return status 200 after delete" do
        user1 = Fabricate(:user)
        device = Fabricate(:device, user_id: user1.id)
        record1 = Fabricate(:record, user_id: user1.id, update_time: Time.now - 1.hour)
        record2 = Fabricate(:record, user_id: user1.id, update_time: Time.now - 1.hour)
        post :delete_all, body: {user: user1.email, device: device.uuid, record_table: [{hash_key: record1.hash_key, update_time: Time.now},{hash_key: record2.hash_key, update_time: Time.now}]}
        response.response_code.should == 200
      end

    end

    context "with invalid input" do
      
      it "return status 404" do
        device = Fabricate(:device)
        record1 = Fabricate(:record)
        record2 = Fabricate(:record)
        post :delete_all, body: {user: "bad_id"}
        response.response_code.should == 404
      end

      it "do not delete data" do
        device = Fabricate(:device)
        record1 = Fabricate(:record)
        record2 = Fabricate(:record)
        post :delete_all, body: {user: "bad_id",device: device.uuid, record_table: [{hash_key: record1.hash_key},{hash_key: record2.hash_key}]}
        expect(record1.reload.is_delete).to be_false
        expect(record2.reload.is_delete).to be_false
      end
    end

  end
end
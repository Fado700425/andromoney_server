require 'spec_helper'

describe Api::V1::DeleteDatasController do

  describe "Delete destroy" do

    context "with valid input" do

      it "create user or device if do not find in database" do
        post :delete_all, {id: Faker::Internet.email, device: Faker::Lorem.characters(20), records: [{hash_key: Faker::Lorem.characters(20)},{hash_key: Faker::Lorem.characters(20)}]}
        expect(User.all.size).to eq(1)
        expect(User.first.devices.size).to eq(1)
      end

      it "update device sync_start_time before sync" do
        user1 = Fabricate(:user)
        device = Fabricate(:device, user_id: user1.id)
        record1 = Fabricate(:record, user_id: user1.id)
        record2 = Fabricate(:record, user_id: user1.id)
        post :delete_all, {id: user1.email, device: device.uuid, records: [{hash_key: record1.hash_key},{hash_key: record2.hash_key}]}
        expect(device.reload.sync_start_time).not_to be_nil
      end

      it "delete the record data" do
        user1 = Fabricate(:user)
        device = Fabricate(:device, user_id: user1.id)
        record1 = Fabricate(:record, user_id: user1.id)
        record2 = Fabricate(:record, user_id: user1.id)
        post :delete_all, {id: user1.email, device: device.uuid, records: [{hash_key: record1.hash_key},{hash_key: record2.hash_key}]}
        expect(record1.reload.is_delete).to be_true
        expect(record2.reload.is_delete).to be_true
      end

      it "do not delete the record data which not belong to the user" do
        user1 = Fabricate(:user)
        user2 = Fabricate(:user)
        device = Fabricate(:device, user_id: user1.id)
        record1 = Fabricate(:record, user_id: user1.id)
        record2 = Fabricate(:record, user_id: user2.id)
        post :delete_all, {id: user1.email, device: device.uuid, records: [{hash_key: record1.hash_key},{hash_key: record2.hash_key}]}
        expect(record1.reload.is_delete).to be_true
        expect(record2.reload.is_delete).to be_false
      end

      it "delete the category data" do
        user1 = Fabricate(:user)
        user2 = Fabricate(:user)
        device = Fabricate(:device, user_id: user1.id)
        category1 = Fabricate(:category, user_id: user1.id)
        category2 = Fabricate(:category, user_id: user2.id)
        post :delete_all, {id: user1.email, device: device.uuid, categories: [{hash_key: category1.hash_key},{hash_key: category2.hash_key}]}
        expect(category1.reload.is_delete).to be_true
        expect(category2.reload.is_delete).to be_false
      end

      it "delete the payee data" do
        user1 = Fabricate(:user)
        user2 = Fabricate(:user)
        device = Fabricate(:device, user_id: user1.id)
        payee1 = Fabricate(:payee, user_id: user1.id)
        payee2 = Fabricate(:payee, user_id: user2.id)
        post :delete_all, {id: user1.email, device: device.uuid, payees: [{hash_key: payee1.hash_key},{hash_key: payee2.hash_key}]}
        expect(payee1.reload.is_delete).to be_true
        expect(payee2.reload.is_delete).to be_false
      end

      it "delete the currency data" do
        user1 = Fabricate(:user)
        user2 = Fabricate(:user)
        device = Fabricate(:device, user_id: user1.id)
        currency1 = Fabricate(:currency, user_id: user1.id)
        currency2 = Fabricate(:currency, user_id: user2.id)
        post :delete_all, {id: user1.email, device: device.uuid, currencies: [{currency_code: currency1.currency_code},{currency_code: currency2.currency_code}]}
        expect(currency1.reload.is_delete).to be_true
        expect(currency2.reload.is_delete).to be_false
      end

      it "delete the payment data" do
        user1 = Fabricate(:user)
        user2 = Fabricate(:user)
        device = Fabricate(:device, user_id: user1.id)
        payment1 = Fabricate(:payment, user_id: user1.id)
        payment2 = Fabricate(:payment, user_id: user2.id)
        post :delete_all, {id: user1.email, device: device.uuid, payments: [{hash_key: payment1.hash_key},{hash_key: payment2.hash_key}]}
        expect(payment1.reload.is_delete).to be_true
        expect(payment2.reload.is_delete).to be_false
      end

      it "delete the period data" do
        user1 = Fabricate(:user)
        user2 = Fabricate(:user)
        device = Fabricate(:device, user_id: user1.id)
        period1 = Fabricate(:period, user_id: user1.id)
        period2 = Fabricate(:period, user_id: user2.id)
        post :delete_all, {id: user1.email, device: device.uuid, periods: [{hash_key: period1.hash_key},{hash_key: period2.hash_key}]}
        expect(period1.reload.is_delete).to be_true
        expect(period2.reload.is_delete).to be_false
      end

      it "delete the pref data" do
        user1 = Fabricate(:user)
        user2 = Fabricate(:user)
        device = Fabricate(:device, user_id: user1.id)
        pref1 = Fabricate(:pref, user_id: user1.id)
        pref2 = Fabricate(:pref, user_id: user2.id)
        post :delete_all, {id: user1.email, device: device.uuid, prefs: [{key: pref1.key},{key: pref2.key}]}
        expect(pref1.reload.is_delete).to be_true
        expect(pref2.reload.is_delete).to be_false
      end

      it "delete the project data" do
        user1 = Fabricate(:user)
        user2 = Fabricate(:user)
        device = Fabricate(:device, user_id: user1.id)
        project1 = Fabricate(:project, user_id: user1.id)
        project2 = Fabricate(:project, user_id: user2.id)
        post :delete_all, {id: user1.email, device: device.uuid, projects: [{hash_key: project1.hash_key},{hash_key: project2.hash_key}]}
        expect(project1.reload.is_delete).to be_true
        expect(project2.reload.is_delete).to be_false
      end

      it "delete the subcategory data" do
        user1 = Fabricate(:user)
        user2 = Fabricate(:user)
        device = Fabricate(:device, user_id: user1.id)
        subcategory1 = Fabricate(:subcategory, user_id: user1.id)
        subcategory2 = Fabricate(:subcategory, user_id: user2.id)
        post :delete_all, {id: user1.email, device: device.uuid, subcategories: [{hash_key: subcategory1.hash_key},{hash_key: subcategory2.hash_key}]}
        expect(subcategory1.reload.is_delete).to be_true
        expect(subcategory2.reload.is_delete).to be_false
      end


      it "return status 200 after delete" do
        user1 = Fabricate(:user)
        device = Fabricate(:device, user_id: user1.id)
        record1 = Fabricate(:record, user_id: user1.id)
        record2 = Fabricate(:record, user_id: user1.id)
        post :delete_all, {id: user1.email, device: device.uuid, records: [{hash_key: record1.hash_key},{hash_key: record2.hash_key}]}
        response.response_code.should == 200
      end

    end

    context "with invalid input" do
      
      it "return status 404" do
        device = Fabricate(:device)
        record1 = Fabricate(:record)
        record2 = Fabricate(:record)
        post :delete_all, {id: "bad_id"}
        response.response_code.should == 404
      end

      it "do not delete data" do
        device = Fabricate(:device)
        record1 = Fabricate(:record)
        record2 = Fabricate(:record)
        post :delete_all, {id: "bad_id",device: device.uuid, records: [{hash_key: record1.hash_key},{hash_key: record2.hash_key}]}
        expect(record1.reload.is_delete).to be_false
        expect(record2.reload.is_delete).to be_false
      end
    end

  end
end
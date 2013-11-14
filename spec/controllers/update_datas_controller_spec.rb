require 'spec_helper'

describe Api::V1::UpdateDatasController do

  describe "Delete destroy" do

    context "with valid input" do

      context "update_time is out of date" do
        it "only update the record data which update_time is newer" do
          user1 = Fabricate(:user)
          device = Fabricate(:device, user_id: user1.id)
          record1 = Fabricate(:record, user_id: user1.id, amount_to_main: 25, update_time: Time.now - 1.hour)
          record2 = Fabricate(:record, user_id: user1.id, amount_to_main: 25, update_time: Time.now - 1.hour)
          post :update_all, body: {user: user1.email,device: device.uuid, record_table: [{hash_key: record1.hash_key, amount_to_main: 50.5,update_time: Time.now - 2.hour },{hash_key: record2.hash_key, amount_to_main: 50.5,update_time: Time.now}]}
          expect(record1.reload.amount_to_main).to eq(25)
          expect(record2.reload.amount_to_main).to eq(50.5)
        end
      end

      context "update_time is newer" do

        it "update the record data" do
          user1 = Fabricate(:user)
          device = Fabricate(:device, user_id: user1.id)
          record1 = Fabricate(:record, user_id: user1.id, amount_to_main: 25, update_time: Time.now - 1.hour)
          record2 = Fabricate(:record, user_id: user1.id, amount_to_main: 25, update_time: Time.now - 1.hour)
          post :update_all, body: {user: user1.email,device: device.uuid, record_table: [{hash_key: record1.hash_key, amount_to_main: 50.5,update_time: Time.now},{hash_key: record2.hash_key, amount_to_main: 50.5,update_time: Time.now}]}
          expect(record1.reload.amount_to_main).to eq(50.5)
          expect(record2.reload.amount_to_main).to eq(50.5)
        end

        it "do not update the record data which not belong to the user" do
          user1 = Fabricate(:user)
          user2 = Fabricate(:user)
          device = Fabricate(:device, user_id: user1.id)
          record1 = Fabricate(:record, user_id: user1.id, amount_to_main: 25, update_time: Time.now - 1.hour)
          record2 = Fabricate(:record, user_id: user2.id, amount_to_main: 25, update_time: Time.now - 1.hour)
          post :update_all, body: {user: user1.email,device: device.uuid, record_table: [{hash_key: record1.hash_key, amount_to_main: 50.5,update_time: Time.now},{hash_key: record2.hash_key, amount_to_main: 50.5,update_time: Time.now}]}
          expect(record1.reload.amount_to_main).to eq(50.5)
          expect(record2.reload.amount_to_main).to eq(25)
        end

        it "update the record data is_delete to false" do
          user1 = Fabricate(:user)
          device = Fabricate(:device, user_id: user1.id)
          record1 = Fabricate(:record, user_id: user1.id, amount_to_main: 25, update_time: Time.now - 1.hour, is_delete: true)
          post :update_all, body: {user: user1.email,device: device.uuid, record_table: [{hash_key: record1.hash_key, amount_to_main: 50.5,update_time: Time.now}]}
          expect(record1.reload.is_delete).to be_false
        end

        it "update the category data" do
          user1 = Fabricate(:user)
          user2 = Fabricate(:user)
          device = Fabricate(:device, user_id: user1.id)
          category1 = Fabricate(:category, user_id: user1.id,category: "Food", update_time: Time.now - 1.hour)
          category2 = Fabricate(:category, user_id: user2.id,category: "Food", update_time: Time.now - 1.hour)
          post :update_all, body: {user: user1.email, device: device.uuid, category_table: [{hash_key: category1.hash_key, category: "BestFood", update_time: Time.now},{hash_key: category2.hash_key, category: "BestFood", update_time: Time.now}]}
          expect(category1.reload.category).to eq("BestFood")
          expect(category2.reload.category).to eq("Food")
        end

        it "update the payee data" do
          user1 = Fabricate(:user)
          user2 = Fabricate(:user)
          device = Fabricate(:device, user_id: user1.id)
          payee1 = Fabricate(:payee, user_id: user1.id,payee_name: "John", update_time: Time.now - 1.hour)
          payee2 = Fabricate(:payee, user_id: user2.id,payee_name: "John", update_time: Time.now - 1.hour)
          post :update_all, body: {user: user1.email, device: device.uuid, payee_table: [{hash_key: payee1.hash_key,payee_name: "Mary", update_time: Time.now},{hash_key: payee2.hash_key,payee_name: "Mary", update_time: Time.now}]}
          expect(payee1.reload.payee_name).to eq("Mary")
          expect(payee2.reload.payee_name).to eq("John")
        end

        it "update the currency data" do
          user1 = Fabricate(:user)
          user2 = Fabricate(:user)
          device = Fabricate(:device, user_id: user1.id)
          currency1 = Fabricate(:currency, user_id: user1.id,rate: 3.672998, update_time: Time.now - 1.hour)
          currency2 = Fabricate(:currency, user_id: user2.id,rate: 3.672998, update_time: Time.now - 1.hour)
          post :update_all, body: {user: user1.email, device: device.uuid, currency_table: [{currency_code: currency1.currency_code, rate: 3.9, update_time: Time.now},{currency_code: currency2.currency_code,rate: 3.9, update_time: Time.now}]}
          expect(currency1.reload.rate).to eq(3.9)
          expect(currency2.reload.rate).to eq(3.672998)
        end

        it "update the payment data" do
          user1 = Fabricate(:user)
          user2 = Fabricate(:user)
          device = Fabricate(:device, user_id: user1.id)
          payment1 = Fabricate(:payment, user_id: user1.id, payment_name: "Cash", update_time: Time.now - 1.hour)
          payment2 = Fabricate(:payment, user_id: user2.id, payment_name: "Cash", update_time: Time.now - 1.hour)
          post :update_all, body: {user: user1.email, device: device.uuid, payment_table: [{hash_key: payment1.hash_key, payment_name: "Bank", update_time: Time.now},{hash_key: payment2.hash_key, payment_name: "Bank", update_time: Time.now}]}
          expect(payment1.reload.payment_name).to eq("Bank")
          expect(payment2.reload.payment_name).to eq("Cash")
        end


        ### datetime send data
        it "update the period data" do
          user1 = Fabricate(:user)
          user2 = Fabricate(:user)
          device = Fabricate(:device, user_id: user1.id)
          period1 = Fabricate(:period, user_id: user1.id, period_num: 2, update_time: Time.now - 1.hour)
          period2 = Fabricate(:period, user_id: user2.id, period_num: 2, update_time: Time.now - 1.hour)
          post :update_all, body: {user: user1.email, device: device.uuid, period_table: [{hash_key: period1.hash_key, period_num: 1, update_time: Time.now},{hash_key: period2.hash_key, period_num: 1, update_time: Time.now}]}
          expect(period1.reload.period_num).to eq(1)
          expect(period2.reload.period_num).to eq(2)
        end

        it "update the pref data" do
          user1 = Fabricate(:user)
          user2 = Fabricate(:user)
          device = Fabricate(:device, user_id: user1.id)
          pref1 = Fabricate(:pref, user_id: user1.id,value: "a", update_time: Time.now - 1.hour)
          pref2 = Fabricate(:pref, user_id: user2.id,value: "a", update_time: Time.now - 1.hour)
          post :update_all, body: {user: user1.email, device: device.uuid, pref_table: [{key: pref1.key,value: "b", update_time: Time.now},{key: pref2.key,value: "b", update_time: Time.now}]}
          expect(pref1.reload.value).to eq("b")
          expect(pref2.reload.value).to eq("a")
        end

        it "update the project data" do
          user1 = Fabricate(:user)
          user2 = Fabricate(:user)
          device = Fabricate(:device, user_id: user1.id)
          project1 = Fabricate(:project, user_id: user1.id, project_name: "Eat", update_time: Time.now - 1.hour)
          project2 = Fabricate(:project, user_id: user2.id, project_name: "Eat", update_time: Time.now - 1.hour)
          post :update_all, body: {user: user1.email, device: device.uuid, project_table: [{hash_key: project1.hash_key, project_name: "Fat", update_time: Time.now},{hash_key: project2.hash_key, project_name: "Fat", update_time: Time.now}]}
          expect(project1.reload.project_name).to eq("Fat")
          expect(project2.reload.project_name).to eq("Eat")
        end

        it "update the subcategory data" do
          user1 = Fabricate(:user)
          user2 = Fabricate(:user)
          device = Fabricate(:device, user_id: user1.id)
          subcategory1 = Fabricate(:subcategory, user_id: user1.id, subcategory: "bag", update_time: Time.now - 1.hour)
          subcategory2 = Fabricate(:subcategory, user_id: user2.id, subcategory: "bag", update_time: Time.now - 1.hour)
          post :update_all, body: {user: user1.email, device: device.uuid, subcategory_table: [{hash_key: subcategory1.hash_key, subcategory: "shoe", update_time: Time.now},{hash_key: subcategory2.hash_key, subcategory: "shoe", update_time: Time.now}]}
          expect(subcategory1.reload.subcategory).to eq("shoe")
          expect(subcategory2.reload.subcategory).to eq("bag")
        end

        it "return status 200 after update" do
          user1 = Fabricate(:user)
          device = Fabricate(:device, user_id: user1.id)
          record1 = Fabricate(:record, user_id: user1.id, amount_to_main: 25, update_time: Time.now - 1.hour)
          record2 = Fabricate(:record, user_id: user1.id, amount_to_main: 25, update_time: Time.now - 1.hour)
          post :update_all, body: {user: user1.email,device: device.uuid, record_table: [{hash_key: record1.hash_key, amount_to_main: 50.5, update_time: Time.now},{hash_key: record2.hash_key, amount_to_main: 50.5, update_time: Time.now}]}
          response.response_code.should == 200
        end
      end

    end

    context "with invalid input" do
      it "return status 404" do
        device = Fabricate(:device)
        record1 = Fabricate(:record)
        record2 = Fabricate(:record)
        post :update_all, body: {user: "bad_id"}
        response.response_code.should == 404
      end

      it "do not update data" do
        device = Fabricate(:device)
        record1 = Fabricate(:record, amount_to_main: 25)
        record2 = Fabricate(:record, amount_to_main: 25)
        post :update_all, body: {user: "bad_id",device: device.uuid, record_table: [{hash_key: record1.hash_key, amount_to_main: 50.5},{hash_key: record2.hash_key, amount_to_main: 50.5}]}
        expect(record1.reload.amount_to_main).to eq(25)
        expect(record2.reload.amount_to_main).to eq(25)
      end
    end

  end
end
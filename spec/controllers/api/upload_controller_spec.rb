require 'spec_helper'

describe Api::V1::UploadController do
  
  context "with valid input" do
    
    context "other tables" do
      it "create the category data" do
        user1 = Fabricate(:user)
        device = Fabricate(:device, user_id: user1.id)
        post :other_tables, {body:{user: user1.email, device: device.uuid, category_table: {insert: [{hash_key: Faker::Lorem.characters(20), category: "BestFood", type: 1, photo_path: "ttt/a.jpg", hidden: 1, update_time: Time.now}]}}}
        expect(Category.all.size).to eq(1)
      end
      it "update the category data" do
        user1 = Fabricate(:user)
        user2 = Fabricate(:user)
        device = Fabricate(:device, user_id: user1.id)
        category1 = Fabricate(:category, user_id: user1.id,category: "Food", update_time: Time.now - 1.hour)
        category2 = Fabricate(:category, user_id: user2.id,category: "Food", update_time: Time.now - 1.hour)
        post :other_tables, body: {user: user1.email, device: device.uuid, category_table: {update: [{hash_key: category1.hash_key, category: "BestFood", update_time: Time.now},{hash_key: category2.hash_key, category: "BestFood", update_time: Time.now}]}}
        expect(category1.reload.category).to eq("BestFood")
        expect(category2.reload.category).to eq("Food")
      end
      it "delete the category data" do
        user1 = Fabricate(:user)
        user2 = Fabricate(:user)
        device = Fabricate(:device, user_id: user1.id)
        category1 = Fabricate(:category, user_id: user1.id, update_time: Time.now - 1.hour)
        category2 = Fabricate(:category, user_id: user2.id, update_time: Time.now - 1.hour)
        post :other_tables, body: {user: user1.email, device: device.uuid, category_table: {delete: [{hash_key: category1.hash_key, update_time: Time.now},{hash_key: category2.hash_key, update_time: Time.now}]}}
        expect(category1.reload.is_delete).to be true
        expect(category2.reload.is_delete).to be false
      end
    end

    context "record_table" do
      it "create the record data" do
        user1 = Fabricate(:user)
        device = Fabricate(:device, user_id: user1.id)
        rightNow = DateTime.now.utc.strftime("%Y/%m/%d/ %H:%M")
        post :record_table, {body: {user: user1.email,device: device.uuid, insert: [{hash_key: Faker::Lorem.characters(20), amount_to_main: 50.5, date: rightNow },{hash_key: Faker::Lorem.characters(20), amount_to_main: 50.5, date: rightNow }], update: [], delete: []}}
        expect(Record.all.size).to eq(2)
      end
      it "update the record data" do
        user1 = Fabricate(:user)
        device = Fabricate(:device, user_id: user1.id)
        record1 = Fabricate(:record, user_id: user1.id, amount_to_main: 25, update_time: Time.now - 1.hour)
        record2 = Fabricate(:record, user_id: user1.id, amount_to_main: 25, update_time: Time.now - 1.hour)
        post :record_table, body: {user: user1.email,device: device.uuid, update: [{hash_key: record1.hash_key, amount_to_main: 50.5,update_time: Time.now},{hash_key: record2.hash_key, amount_to_main: 50.5,update_time: Time.now}]}
        expect(record1.reload.amount_to_main).to eq(50.5)
        expect(record2.reload.amount_to_main).to eq(50.5)
      end
      it "delete the record data" do
        user1 = Fabricate(:user)
        device = Fabricate(:device, user_id: user1.id)
        record1 = Fabricate(:record, user_id: user1.id, update_time: Time.now - 100.hour)
        record2 = Fabricate(:record, user_id: user1.id, update_time: Time.now - 100.hour)
        post :record_table, body: {user: user1.email, device: device.uuid, delete: [{hash_key: record1.hash_key, update_time: Time.now},{hash_key: record2.hash_key, update_time: Time.now}]}
        expect(record1.reload.is_delete).to be true
        expect(record2.reload.is_delete).to be true
      end
    end
  end

end
require 'spec_helper'

describe Api::V1::GetDeviceAddDatasController do

  describe "get Index" do

    context "with valid user data" do
      
      it "return user need data(record)" do
        user1 = Fabricate(:user)
        record1 = Fabricate(:record, user_id: user1.id, device_uuid: Faker::Lorem.characters(20))
        record2 = Fabricate(:record, user_id: user1.id, device_uuid: Faker::Lorem.characters(20))
        device = Fabricate(:device, user_id: user1.id, last_sync_time: Time.now - 3.days, sync_start_time: Time.now)
        get :index, {user: user1.email,device: device.uuid, table: "record_table", sync_time: Time.now - 3.days}
        body = ActiveSupport::JSON.decode(response.body)
        expect(body["datas"].size).to eq(2)
      end

      it "only return data where device not equal request device_uuid" do
        user1 = Fabricate(:user)
        record1 = Fabricate(:record, user_id: user1.id, device_uuid: Faker::Lorem.characters(20))
        device = Fabricate(:device, user_id: user1.id, last_sync_time: Time.now - 3.days, sync_start_time: Time.now)
        record2 = Fabricate(:record, user_id: user1.id, device_uuid: device.uuid)
        get :index, {user: user1.email,device: device.uuid, table: "record_table", sync_time: Time.now - 3.days}
        body = ActiveSupport::JSON.decode(response.body)
        expect(body["datas"].size).to eq(1)
      end

      it "return user need data(category)" do
        user1 = Fabricate(:user)
        category1 = Fabricate(:category, user_id: user1.id,category: "Food", device_uuid: Faker::Lorem.characters(20))
        device = Fabricate(:device, user_id: user1.id, last_sync_time: Time.now - 3.days, sync_start_time: Time.now)
        get :index, {user: user1.email,device: device.uuid, table: "category_table", sync_time: Time.now - 3.days}
        body = ActiveSupport::JSON.decode(response.body)
        expect(body["datas"].size).to eq(1)
      end

      it "return user need data(payee)" do
        user1 = Fabricate(:user)
        payee1 = Fabricate(:payee, user_id: user1.id,payee_name: "John", device_uuid: Faker::Lorem.characters(20))
        device = Fabricate(:device, user_id: user1.id, last_sync_time: Time.now - 3.days, sync_start_time: Time.now)
        get :index, {user: user1.email,device: device.uuid, table: "payee_table", sync_time: Time.now - 3.days}
        body = ActiveSupport::JSON.decode(response.body)
        expect(body["datas"].size).to eq(1)
      end

      it "return user need data(currency)" do
        user1 = Fabricate(:user)
        currency1 = Fabricate(:currency, user_id: user1.id,rate: 3.672998, device_uuid: Faker::Lorem.characters(20))
        device = Fabricate(:device, user_id: user1.id, last_sync_time: Time.now - 3.days, sync_start_time: Time.now)
        get :index, {user: user1.email,device: device.uuid, table: "currency_table", sync_time: Time.now - 3.days}
        body = ActiveSupport::JSON.decode(response.body)
        expect(body["datas"].size).to eq(1)
      end

      it "return user need data(payment)" do
        user1 = Fabricate(:user)
        payment1 = Fabricate(:payment, user_id: user1.id, payment_name: "Cash", device_uuid: Faker::Lorem.characters(20))
        device = Fabricate(:device, user_id: user1.id, last_sync_time: Time.now - 3.days, sync_start_time: Time.now)
        get :index, {user: user1.email,device: device.uuid, table: "payment_table", sync_time: Time.now - 3.days}
        body = ActiveSupport::JSON.decode(response.body)
        expect(body["datas"].size).to eq(1)
      end

      it "return user need data(period)" do
        user1 = Fabricate(:user)
        period1 = Fabricate(:period, user_id: user1.id, period_num: 2, device_uuid: Faker::Lorem.characters(20))
        device = Fabricate(:device, user_id: user1.id, last_sync_time: Time.now - 3.days, sync_start_time: Time.now)
        get :index, {user: user1.email,device: device.uuid, table: "period_table", sync_time: Time.now - 3.days}
        body = ActiveSupport::JSON.decode(response.body)
        expect(body["datas"].size).to eq(1)
      end

      it "return user need data(pref)" do
        user1 = Fabricate(:user)
        pref1 = Fabricate(:pref, user_id: user1.id,value: "a", device_uuid: Faker::Lorem.characters(20))
        device = Fabricate(:device, user_id: user1.id, last_sync_time: Time.now - 3.days, sync_start_time: Time.now)
        get :index, {user: user1.email,device: device.uuid, table: "pref_table", sync_time: Time.now - 3.days}
        body = ActiveSupport::JSON.decode(response.body)
        expect(body["datas"].size).to eq(1)
      end

      it "return user need data(project)" do
        user1 = Fabricate(:user)
        project1 = Fabricate(:project, user_id: user1.id, project_name: "Eat", device_uuid: Faker::Lorem.characters(20))
        device = Fabricate(:device, user_id: user1.id, last_sync_time: Time.now - 3.days, sync_start_time: Time.now)
        get :index, {user: user1.email,device: device.uuid, table: "project_table", sync_time: Time.now - 3.days}
        body = ActiveSupport::JSON.decode(response.body)
        expect(body["datas"].size).to eq(1)
      end

      it "return user need data(subcategory)" do
        user1 = Fabricate(:user)
        subcategory1 = Fabricate(:subcategory, user_id: user1.id, subcategory: "bag", device_uuid: Faker::Lorem.characters(20))
        device = Fabricate(:device, user_id: user1.id, last_sync_time: Time.now - 3.days, sync_start_time: Time.now)
        get :index, {user: user1.email,device: device.uuid, table: "subcategory_table", sync_time: Time.now - 3.days}
        body = ActiveSupport::JSON.decode(response.body)
        expect(body["datas"].size).to eq(1)
      end
      
      it "return status 200 after get" do
        user1 = Fabricate(:user)
        subcategory1 = Fabricate(:subcategory, user_id: user1.id, subcategory: "bag", device_uuid: Faker::Lorem.characters(20))
        device = Fabricate(:device, user_id: user1.id, last_sync_time: Time.now - 3.days, sync_start_time: Time.now)
        get :index, {user: user1.email,device: device.uuid, table: "subcategory_table", sync_time: Time.now - 3.days}
        body = ActiveSupport::JSON.decode(response.body)
        expect(body["datas"].size).to eq(1)
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
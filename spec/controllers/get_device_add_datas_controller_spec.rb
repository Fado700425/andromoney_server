require 'spec_helper'

describe Api::V1::GetDeviceAddDatasController do

  describe "get Index" do

    context "with valid user data" do
      
      it "return user need data(record)" do
        user1 = Fabricate(:user)
        record1 = Fabricate(:record, user_id: user1.id)
        record2 = Fabricate(:record, user_id: user1.id)
        device = Fabricate(:device, user_id: user1.id, last_sync_time: Time.now - 3.days, sync_start_time: Time.now)
        get :index, {user: user1.email,device: device.uuid, table_name: "record_table", sync_time: Time.now - 3.days}
        body = ActiveSupport::JSON.decode(response.body)
        expect(body.size).to eq(2)
      end

      it "return user need data(category)" do
        user1 = Fabricate(:user)
        category1 = Fabricate(:category, user_id: user1.id,category: "Food")
        device = Fabricate(:device, user_id: user1.id, last_sync_time: Time.now - 3.days, sync_start_time: Time.now)
        get :index, {user: user1.email,device: device.uuid, table_name: "category_table", sync_time: Time.now - 3.days}
        body = ActiveSupport::JSON.decode(response.body)
        expect(body.size).to eq(1)
      end

      it "return user need data(payee)" do
        user1 = Fabricate(:user)
        payee1 = Fabricate(:payee, user_id: user1.id,payee_name: "John")
        device = Fabricate(:device, user_id: user1.id, last_sync_time: Time.now - 3.days, sync_start_time: Time.now)
        get :index, {user: user1.email,device: device.uuid, table_name: "payee_table", sync_time: Time.now - 3.days}
        body = ActiveSupport::JSON.decode(response.body)
        expect(body.size).to eq(1)
      end

      it "return user need data(currency)" do
        user1 = Fabricate(:user)
        currency1 = Fabricate(:currency, user_id: user1.id,rate: 3.672998)
        device = Fabricate(:device, user_id: user1.id, last_sync_time: Time.now - 3.days, sync_start_time: Time.now)
        get :index, {user: user1.email,device: device.uuid, table_name: "currency_table", sync_time: Time.now - 3.days}
        body = ActiveSupport::JSON.decode(response.body)
        expect(body.size).to eq(1)
      end

      it "return user need data(payment)" do
        user1 = Fabricate(:user)
        payment1 = Fabricate(:payment, user_id: user1.id, payment_name: "Cash")
        device = Fabricate(:device, user_id: user1.id, last_sync_time: Time.now - 3.days, sync_start_time: Time.now)
        get :index, {user: user1.email,device: device.uuid, table_name: "payment_table", sync_time: Time.now - 3.days}
        body = ActiveSupport::JSON.decode(response.body)
        expect(body.size).to eq(1)
      end

      it "return user need data(period)" do
        user1 = Fabricate(:user)
        period1 = Fabricate(:period, user_id: user1.id, period_num: 2)
        device = Fabricate(:device, user_id: user1.id, last_sync_time: Time.now - 3.days, sync_start_time: Time.now)
        get :index, {user: user1.email,device: device.uuid, table_name: "period_table", sync_time: Time.now - 3.days}
        body = ActiveSupport::JSON.decode(response.body)
        expect(body.size).to eq(1)
      end

      it "return user need data(pref)" do
        user1 = Fabricate(:user)
        pref1 = Fabricate(:pref, user_id: user1.id,value: "a")
        device = Fabricate(:device, user_id: user1.id, last_sync_time: Time.now - 3.days, sync_start_time: Time.now)
        get :index, {user: user1.email,device: device.uuid, table_name: "pref_table", sync_time: Time.now - 3.days}
        body = ActiveSupport::JSON.decode(response.body)
        expect(body.size).to eq(1)
      end

      it "return user need data(project)" do
        user1 = Fabricate(:user)
        project1 = Fabricate(:project, user_id: user1.id, project_name: "Eat")
        device = Fabricate(:device, user_id: user1.id, last_sync_time: Time.now - 3.days, sync_start_time: Time.now)
        get :index, {user: user1.email,device: device.uuid, table_name: "project_table", sync_time: Time.now - 3.days}
        body = ActiveSupport::JSON.decode(response.body)
        expect(body.size).to eq(1)
      end

      it "return user need data(subcategory)" do
        user1 = Fabricate(:user)
        subcategory1 = Fabricate(:subcategory, user_id: user1.id, subcategory: "bag")
        device = Fabricate(:device, user_id: user1.id, last_sync_time: Time.now - 3.days, sync_start_time: Time.now)
        get :index, {user: user1.email,device: device.uuid, table_name: "subcategory_table", sync_time: Time.now - 3.days}
        body = ActiveSupport::JSON.decode(response.body)
        expect(body.size).to eq(1)
      end
      
      it "return status 200 after get" do
        user1 = Fabricate(:user)
        subcategory1 = Fabricate(:subcategory, user_id: user1.id, subcategory: "bag")
        device = Fabricate(:device, user_id: user1.id, last_sync_time: Time.now - 3.days, sync_start_time: Time.now)
        get :index, {user: user1.email,device: device.uuid, table_name: "subcategory_table", sync_time: Time.now - 3.days}
        body = ActiveSupport::JSON.decode(response.body)
        expect(body.size).to eq(1)
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
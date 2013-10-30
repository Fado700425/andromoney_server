require 'spec_helper'

describe Api::V1::GetDeviceUpdateDatasController do

  describe "get Index" do

    context "with valid user data" do
      
      it "return user need data(record)" do
        user1 = Fabricate(:user)
        record1 = Fabricate(:record, user_id: user1.id, updated_at: Time.now - 3.days)
        record2 = Fabricate(:record, user_id: user1.id, updated_at: Time.now - 3.days)
        device = Fabricate(:device, user_id: user1.id, last_sync_time: Time.now - 3.days, sync_start_time: Time.now)
        record2.update_attribute(:project_name, "Some Value")
        get :index, {id: user1.email,device: device.uuid}
        body = ActiveSupport::JSON.decode(response.body)
        expect(body["records"].size).to eq(1)
      end

      it "return user need data(category)" do
        user1 = Fabricate(:user)
        category1 = Fabricate(:category, user_id: user1.id,category: "Food", updated_at: Time.now - 3.days)
        category2 = Fabricate(:category, user_id: user1.id,category: "Food", updated_at: Time.now - 3.days)
        device = Fabricate(:device, user_id: user1.id, last_sync_time: Time.now - 3.days, sync_start_time: Time.now)
        category2.update_attribute(:category, "Some Value")
        get :index, {id: user1.email,device: device.uuid}
        body = ActiveSupport::JSON.decode(response.body)
        expect(body["categories"].size).to eq(1)
      end

      it "return user need data(payee)" do
        user1 = Fabricate(:user)
        payee1 = Fabricate(:payee, user_id: user1.id,payee_name: "John", updated_at: Time.now - 3.days)
        payee2 = Fabricate(:payee, user_id: user1.id,payee_name: "John", updated_at: Time.now - 3.days)
        device = Fabricate(:device, user_id: user1.id, last_sync_time: Time.now - 3.days, sync_start_time: Time.now)
        payee2.update_attribute(:payee_name, "Some Value")
        get :index, {id: user1.email,device: device.uuid}
        body = ActiveSupport::JSON.decode(response.body)
        expect(body["payees"].size).to eq(1)
      end

      it "return user need data(currency)" do
        user1 = Fabricate(:user)
        currency1 = Fabricate(:currency, user_id: user1.id,rate: 3.672998, updated_at: Time.now - 3.days)
        currency2 = Fabricate(:currency, user_id: user1.id,rate: 3.672998, updated_at: Time.now - 3.days)
        device = Fabricate(:device, user_id: user1.id, last_sync_time: Time.now - 3.days, sync_start_time: Time.now)
        currency2.update_attribute(:rate, 3.672)
        get :index, {id: user1.email,device: device.uuid}
        body = ActiveSupport::JSON.decode(response.body)
        expect(body["currencies"].size).to eq(1)
      end

      it "return user need data(payment)" do
        user1 = Fabricate(:user)
        payment1 = Fabricate(:payment, user_id: user1.id, payment_name: "Cash", updated_at: Time.now - 3.days)
        payment2 = Fabricate(:payment, user_id: user1.id, payment_name: "Cash", updated_at: Time.now - 3.days)
        device = Fabricate(:device, user_id: user1.id, last_sync_time: Time.now - 3.days, sync_start_time: Time.now)
        payment2.update_attribute(:payment_name, "Some Value")
        get :index, {id: user1.email,device: device.uuid}
        body = ActiveSupport::JSON.decode(response.body)
        expect(body["payments"].size).to eq(1)
      end

      it "return user need data(period)" do
        user1 = Fabricate(:user)
        period1 = Fabricate(:period, user_id: user1.id, period_num: 2, updated_at: Time.now - 3.days)
        period2 = Fabricate(:period, user_id: user1.id, period_num: 2, updated_at: Time.now - 3.days)
        device = Fabricate(:device, user_id: user1.id, last_sync_time: Time.now - 3.days, sync_start_time: Time.now)
        period2.update_attribute(:period_num, 3)
        get :index, {id: user1.email,device: device.uuid}
        body = ActiveSupport::JSON.decode(response.body)
        expect(body["periods"].size).to eq(1)
      end

      it "return user need data(pref)" do
        user1 = Fabricate(:user)
        pref1 = Fabricate(:pref, user_id: user1.id,value: "a", updated_at: Time.now - 3.days)
        pref2 = Fabricate(:pref, user_id: user1.id,value: "a", updated_at: Time.now - 3.days)
        device = Fabricate(:device, user_id: user1.id, last_sync_time: Time.now - 3.days, sync_start_time: Time.now)
        pref2.update_attribute(:value, "b")
        get :index, {id: user1.email,device: device.uuid}
        body = ActiveSupport::JSON.decode(response.body)
        expect(body["prefs"].size).to eq(1)
      end

      it "return user need data(project)" do
        user1 = Fabricate(:user)
        project1 = Fabricate(:project, user_id: user1.id, project_name: "Eat", updated_at: Time.now - 3.days)
        project2 = Fabricate(:project, user_id: user1.id, project_name: "Eat", updated_at: Time.now - 3.days)
        device = Fabricate(:device, user_id: user1.id, last_sync_time: Time.now - 3.days, sync_start_time: Time.now)
        project2.update_attribute(:project_name, "b")
        get :index, {id: user1.email,device: device.uuid}
        body = ActiveSupport::JSON.decode(response.body)
        expect(body["projects"].size).to eq(1)
      end

      it "return user need data(subcategory)" do
        user1 = Fabricate(:user)
        subcategory1 = Fabricate(:subcategory, user_id: user1.id, subcategory: "bag", updated_at: Time.now - 3.days)
        subcategory2 = Fabricate(:subcategory, user_id: user1.id, subcategory: "bag", updated_at: Time.now - 3.days)
        device = Fabricate(:device, user_id: user1.id, last_sync_time: Time.now - 3.days, sync_start_time: Time.now)
        subcategory2.update_attribute(:subcategory, "b")
        get :index, {id: user1.email,device: device.uuid}
        body = ActiveSupport::JSON.decode(response.body)
        expect(body["subcategories"].size).to eq(1)
      end
      
      it "return status 200 after get" do
        user1 = Fabricate(:user)
        subcategory1 = Fabricate(:subcategory, user_id: user1.id, subcategory: "bag", updated_at: Time.now - 3.days)
        subcategory2 = Fabricate(:subcategory, user_id: user1.id, subcategory: "bag", updated_at: Time.now - 3.days)
        device = Fabricate(:device, user_id: user1.id, last_sync_time: Time.now - 3.days, sync_start_time: Time.now)
        subcategory2.update_attribute(:subcategory, "b")
        get :index, {id: user1.email,device: device.uuid}
        response.response_code.should == 200
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
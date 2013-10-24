require 'spec_helper'

describe Api::V1::AddDatasController do
  
  context "with valid input" do

    it "create the record data" do
      user1 = Fabricate(:user)
      device = Fabricate(:device, user_id: user1.id)
      post :create, {body: {user: user1.email,device: device.uuid, records: [{hash_key: Faker::Lorem.characters(20), amount_to_main: 50.5},{hash_key: Faker::Lorem.characters(20), amount_to_main: 50.5}]}.to_json}
      expect(Record.all.size).to eq(2)
    end

    it "the created record data belongs to post user" do
      user1 = Fabricate(:user)
      device = Fabricate(:device, user_id: user1.id)
      post :create, {body:{user: user1.email,device: device.uuid, records: [{hash_key: Faker::Lorem.characters(20), amount_to_main: 50.5},{hash_key: Faker::Lorem.characters(20), amount_to_main: 50.5}]}.to_json}
      expect(Record.first.user_id).to eq(user1.id)
    end

    it "create the category data" do
      user1 = Fabricate(:user)
      device = Fabricate(:device, user_id: user1.id)
      post :create, {body:{user: user1.email, device: device.uuid, category_table: [{hash_key: Faker::Lorem.characters(20), category: "BestFood"}]}.to_json}
      expect(Category.all.size).to eq(1)
    end

    it "create the payee data" do
      user1 = Fabricate(:user)
      device = Fabricate(:device, user_id: user1.id)
      post :create, {body:{user: user1.email, device: device.uuid, payees: [{hash_key: Faker::Lorem.characters(20),payee_name: "Mary"}]}.to_json}
      expect(Payee.all.size).to eq(1)
    end

    it "create the currency data" do
      user1 = Fabricate(:user)
      device = Fabricate(:device, user_id: user1.id)
      post :create, {body: {user: user1.email, device: device.uuid, currencies: [{currency_code: Faker::Lorem.characters(3), rate: 3.9}]}.to_json}
      expect(Currency.all.size).to eq(1)
    end

    it "create the payment data" do
      user1 = Fabricate(:user)
      device = Fabricate(:device, user_id: user1.id)
      post :create, {body: {user: user1.email, device: device.uuid, payments: [{hash_key: Faker::Lorem.characters(20), payment_name: "Bank"}]}.to_json}
      expect(Payment.all.size).to eq(1)
    end

    it "create the period data" do
      user1 = Fabricate(:user)
      device = Fabricate(:device, user_id: user1.id)
      post :create, {body: {user: user1.email, device: device.uuid, periods: [{hash_key: Faker::Lorem.characters(20), preriod_num: 1}]}.to_json}
      expect(Period.all.size).to eq(1)
    end

    it "create the pref data" do
      user1 = Fabricate(:user)
      device = Fabricate(:device, user_id: user1.id)
      post :create, {body: {user: user1.email, device: device.uuid, prefs: [{key: Faker::Lorem.characters(20),value: "b"}]}.to_json}
      expect(Pref.all.size).to eq(1)
    end

    it "create the project data" do
      user1 = Fabricate(:user)
      device = Fabricate(:device, user_id: user1.id)
      post :create,{body: {user: user1.email, device: device.uuid, projects: [{hash_key: Faker::Lorem.characters(20), project_name: "Fat"}]}.to_json}
      expect(Project.all.size).to eq(1)
    end

    it "create the subcategory data" do
      user1 = Fabricate(:user)
      device = Fabricate(:device, user_id: user1.id)
      post :create, {body: {user: user1.email, device: device.uuid, subcategory_table: [{hash_key: Faker::Lorem.characters(20), subcategory: "shoe"}]}.to_json}
      expect(Subcategory.all.size).to eq(1)
    end

    it "return status 200 after update" do
      user1 = Fabricate(:user)
      device = Fabricate(:device, user_id: user1.id)
      post :create, {body: {user: user1.email, device: device.uuid, subcategories: [{hash_key: Faker::Lorem.characters(20), subcategory: "shoe"}]}.to_json}
      response.response_code.should == 200
    end

  end

  context "with invalid input" do
    it "return status 404" do
      post :create, {id: "bad_id"}
      response.response_code.should == 404
    end

    it "do not update data" do
      post :create, {id: "bad_id", records: [{hash_key: Faker::Lorem.characters(20), amount_to_main: 50.5}]}
      expect(Record.all.size).to eq(0)
    end

  end
end
require 'spec_helper'

describe Api::V1::UsersController do

  describe "Get is_user_register" do
    it "return status code 200 if find user" do
      user1 = Fabricate(:user)
      get :is_user_register, user: user1.email
      expect(response.status).to eq(200)
    end

    it "return status code 404 if not find user" do
      get :is_user_register, user: Faker::Internet.email
      expect(response.status).to eq(404)
    end
  end

  describe "Post create" do
    context "with valid input" do
      it "create user" do
        post :create, body: {user: Faker::Internet.email, device: "testid"}
        expect(User.all.size).to eq(1)
      end
      it "create device" do
        post :create, body: {user: Faker::Internet.email, device: "testid"}
        expect(Device.all.size).to eq(1)
      end
      it "return status code 200 if find user" do
        post :create, body: {user: Faker::Internet.email, device: "testid"}
        expect(response.status).to eq(200)
      end
      it "return status code 304 if deplicate user" do
        user1 = Fabricate(:user)
        post :create, body: {user: user1.email, device: "testid"}
        expect(response.status).to eq(304)
      end
    end
    context "with invalid input" do
      it "return status code 404" do
        post :create, body: {user: "bad", device: "testid"}
        expect(response.status).to eq(404)
      end      
    end
  end

end
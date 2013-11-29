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

      context "already have user in db" do
        it "return status code 304" do
          user1 = Fabricate(:user)
          post :create, body: {user: user1.email, device: "testid"}
          expect(response.status).to eq(304)
        end
        it "create device if no device in db" do
          user1 = Fabricate(:user)
          post :create, body: {user: user1.email, device: "testid"}
          expect(Device.all.size).to eq(1)
        end
        it "do not create device if device in db" do
          user1 = Fabricate(:user)
          device = Fabricate(:device, user_id: user1.id)
          post :create, body: {user: user1.email, device: device.uuid}
          expect(Device.all.size).to eq(1)
        end

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
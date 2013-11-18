require 'spec_helper'

describe Api::V1::SyncController do

  context "Post start" do
    
    context "with valid inputs" do
      it "return start_sync_time" do
        user = Fabricate(:user, is_syncing: true, sync_time: Time.now - 1.hour)
        device1 = Fabricate(:device, user_id: user.id)
        post :start, {body: {user: user.email,device: device1.uuid}}
        response.response_code.should == 200
      end
    end

    context "with invalid inputs" do
      it "return status 404" do
        post :start, {body: {user: "test",device: "fake_id"}}
        response.response_code.should == 404
      end
    end
  end
end
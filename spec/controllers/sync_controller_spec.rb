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

  context "Post end" do
    it "update the device last_sync_time" do
      user = Fabricate(:user, is_syncing: true)
      device = Fabricate(:device, user_id: user.id, is_syncing: true)
      sync_time = Time.now.utc
      post :end, {body: {user: user.email,device: device.uuid, sync_time: sync_time}}
      device.reload.last_sync_time.utc.to_i.should == sync_time.to_i
    end
  end
end
require 'spec_helper'

describe Api::V1::SyncController do

  context "Post start" do
    
    context "with valid inputs" do
      it "set user is_syncing to true" do
        user = Fabricate(:user)
        device = Fabricate(:device, user_id: user.id)
        post :start, {body: {user: user.email,device: device.uuid}.to_json}
        user.reload.is_syncing.should == true
      end

      it "set device is_syncing to true" do
        user = Fabricate(:user)
        device = Fabricate(:device, user_id: user.id)
        post :start, {body: {user: user.email,device: device.uuid}.to_json}
        device.reload.is_syncing.should == true
      end

      it "set user sync time" do
        user = Fabricate(:user)
        device = Fabricate(:device, user_id: user.id)
        post :start, {body: {user: user.email,device: device.uuid}.to_json}
        expect(user.reload.sync_time > Time.now - 1.hour).to be_true
      end
      it "set the device start sync time" do
        user = Fabricate(:user)
        device = Fabricate(:device, user_id: user.id)
        post :start, {body: {user: user.email,device: device.uuid}.to_json}
        expect(device.reload.sync_start_time > Time.now - 1.hour).to be_true
      end
      it "return status 403 if the other device is syncing" do
        user = Fabricate(:user)
        device1 = Fabricate(:device, user_id: user.id)
        device2 = Fabricate(:device, user_id: user.id)
        post :start, {body: {user: user.email,device: device1.uuid}.to_json}
        post :start, {body: {user: user.email,device: device2.uuid}.to_json}
        response.response_code.should == 403
      end
      it "allow to sync if user last start_sync_time is before 10min" do
        user = Fabricate(:user, is_syncing: true, sync_time: Time.now - 1.hour)
        device1 = Fabricate(:device, user_id: user.id)
        post :start, {body: {user: user.email,device: device1.uuid}.to_json}
        response.response_code.should == 200
      end
    end

    context "with invalid inputs" do
      it "return status 404" do
        post :start, {body: {user: "test",device: "fake_id"}.to_json}
        response.response_code.should == 404
      end
    end

  end

  context "Post end" do

    context "with valid inputs" do
      it "set user is_syncing to false" do
        user = Fabricate(:user, is_syncing: true)
        device = Fabricate(:device, user_id: user.id, is_syncing: true)
        post :end, {body: {user: user.email,device: device.uuid}.to_json}
        user.reload.is_syncing.should == false
      end

      it "set device is_syncing to false" do
        user = Fabricate(:user, is_syncing: true)
        device = Fabricate(:device, user_id: user.id, is_syncing: true)
        post :end, {body: {user: user.email,device: device.uuid}.to_json}
        device.reload.is_syncing.should == false
      end

      it "set the device last sync time" do
        user = Fabricate(:user, is_syncing: true)
        device = Fabricate(:device, user_id: user.id, is_syncing: true)
        post :end, {body: {user: user.email,device: device.uuid}.to_json}
        expect(device.reload.last_sync_time > Time.now - 1.hour).to be_true
      end

      it "return status 403 if is not the syncing device" do
        user = Fabricate(:user, is_syncing: true)
        device1 = Fabricate(:device, user_id: user.id, is_syncing: true)
        device2 = Fabricate(:device, user_id: user.id)
        post :end, {body: {user: user.email,device: device2.uuid}.to_json}
        response.response_code.should == 403
      end
    end

    context "with invalid inputs" do
      it "return status 404" do
        post :end, {body: {user: "test",device: "fake_id"}.to_json}
        response.response_code.should == 404
      end
    end
  end

end
require 'spec_helper'

describe Api::V1::AdsController do

  describe "Post click" do
    context "with valid input" do

      it "return status code 200 if find user" do
        post :click, body: {email: Faker::Internet.email, uuid: "testid", ad_id: 1}
        expect(response.status).to eq(200)
      end
    end
  end

end
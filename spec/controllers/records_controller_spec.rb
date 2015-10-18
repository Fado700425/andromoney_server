require 'spec_helper'

ActiveRecord::Base.logger = Logger.new(STDOUT) if defined?(ActiveRecord::Base)

describe RecordsController do

  describe "Delete destroy" do
    it "delete the record" do
      record = Fabricate(:record)
      delete :destroy, id: record, month_from_now: 2
      Record.first.is_delete.should == true
    end
    # it "ask whether to delete the period record"
  end

  describe "Get records' json by ajax" do
    before(:each) do
      @user = Fabricate(:user)
      @user.categories << Fabricate(:category)
      @user.save()
      currency= Fabricate(:currency, currency_code: 'AZN', sequence_status: 0)
      @user.currencies << currency
    end

    it "json response should contains id & date" do
      record = Fabricate(:record)
      record.user = @user
      record.save
      category = Fabricate(:category)
      category.user = @user
      category.save
      record.category = category.hash_key
      subcategory = Fabricate(:subcategory)
      subcategory.user = @user
      subcategory.save
      record.subcategory = subcategory.hash_key
      record.save



      xhr :get, :index, {start: record.date.at_beginning_of_day.strftime('%Y-%m-%d'), end: record.date.at_end_of_day.strftime('%Y-%m-%d'), view: 'month'}, {user_id: @user.id}
      p response.body
      json_response = JSON.parse(response.body)
      expect(json_response['records'][0]['id']).not_to be_nil
      expect(json_response['records'][0]['date']).not_to be_empty
      expect(json_response['records'][0]['record_category']['category']).not_to be_empty
      expect(json_response['records'][0]['record_subcategory']['subcategory']).not_to be_empty
    end
  end
end
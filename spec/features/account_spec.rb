require 'spec_helper'

feature "account", :omniauth, js: true do
  given(:john) { create_user('john@andromoney.com', 'John Doe', 1) }

  background do
    signin(john)
    set_user_assest(john)
  end

  before(:all) do
    Fabricate(:record, user_id: john.id, mount: 10, currency_code: 'ARS', update_time: Time.now - 1.hour, updated_at: Time.now - 1.hour, date: Time.now - 1.hour)
    Fabricate(:record, user_id: john.id, mount: 100, currency_code: 'BDT', update_time: Time.now - 1.hour, updated_at: Time.now - 1.hour, date: Time.now - 1.hour)
    Fabricate(:record, user_id: john.id, mount: 500, currency_code: 'EUR', update_time: Time.now - 1.hour, updated_at: Time.now - 1.hour, date: Time.now - 1.hour)
    Fabricate(:record, user_id: john.id, mount: 2000, currency_code: 'JMD', update_time: Time.now - 1.hour, updated_at: Time.now - 1.hour, date: Time.now - 1.hour)
    Fabricate(:record, user_id: john.id, mount: 5000, currency_code: 'VND', update_time: Time.now - 1.hour, updated_at: Time.now - 1.hour, date: Time.now - 1.hour)
    Fabricate(:record, user_id: john.id, mount: 10000, currency_code: 'YER', update_time: Time.now - 1.hour, updated_at: Time.now - 1.hour, date: Time.now - 1.hour)
    Fabricate(:record, user_id: john.id, mount: 20000, currency_code: 'TWD', update_time: Time.now - 1.hour, updated_at: Time.now - 1.hour, date: Time.now - 1.hour) 
  end

  describe 'New page' do
    it "update to USD" do
    end
  end
end
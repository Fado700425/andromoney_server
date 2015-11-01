require 'spec_helper'

feature "account", :omniauth  do
  given(:john) { create_user('john@andromoney.com', 'John Doe', 1) }

  background do
    signin(john)
    Fabricate(:record, user: john, mount: 10, currency_code: 'ARS', update_time: Time.now - 1.hour, updated_at: Time.now - 1.hour, date: Time.now - 1.hour)
    Fabricate(:record, user: john, mount: 100, currency_code: 'BDT', update_time: Time.now - 1.hour, updated_at: Time.now - 1.hour, date: Time.now - 1.hour)
    Fabricate(:record, user: john, mount: 500, currency_code: 'EUR', update_time: Time.now - 1.hour, updated_at: Time.now - 1.hour, date: Time.now - 1.hour)
    Fabricate(:record, user: john, mount: 2000, currency_code: 'JMD', update_time: Time.now - 1.hour, updated_at: Time.now - 1.hour, date: Time.now - 1.hour)
    Fabricate(:record, user: john, mount: 5000, currency_code: 'VND', update_time: Time.now - 1.hour, updated_at: Time.now - 1.hour, date: Time.now - 1.hour)
    Fabricate(:record, user: john, mount: 10000, currency_code: 'YER', update_time: Time.now - 1.hour, updated_at: Time.now - 1.hour, date: Time.now - 1.hour)
    Fabricate(:record, user: john, mount: 20000, currency_code: 'TWD', update_time: Time.now - 1.hour, updated_at: Time.now - 1.hour, date: Time.now - 1.hour) 
  end

  describe 'test main currency switch' do
    it "update to USD" do
      visit '/accounts/main_currency'
      #get 'accounts/main_currency'
      #post 'setting/update', selected_currency: 'USD'
      #expect(Currency.where('user_id = ? AND sequence_status = ?', session[:user_id], 0)[0].currency_code).to eq('USD')
      #expect(flash[:success]).to be_present

      #get 'setting/edit'
      #post 'setting/update', selected_currency: 'TWD'
      #expect(flash[:danger]).to be_present
    end
  end
end
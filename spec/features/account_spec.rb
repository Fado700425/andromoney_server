require 'spec_helper'

feature "account", :omniauth, js: true  do
  given(:john) { create_user('john@andromoney.com', 'John Doe', 1) }

  background do
    signin(john)
    set_user_assest(john)
    Fabricate(:record, user: john, mount: 10, currency_code: 'ARS', update_time: Time.now - 1.hour, updated_at: Time.now - 1.hour, date: Time.now - 1.hour)
    Fabricate(:record, user: john, mount: 100, currency_code: 'BDT', update_time: Time.now - 1.hour, updated_at: Time.now - 1.hour, date: Time.now - 1.hour)
    Fabricate(:record, user: john, mount: 500, currency_code: 'EUR', update_time: Time.now - 1.hour, updated_at: Time.now - 1.hour, date: Time.now - 1.hour)
    Fabricate(:record, user: john, mount: 2000, currency_code: 'JMD', update_time: Time.now - 1.hour, updated_at: Time.now - 1.hour, date: Time.now - 1.hour)
    Fabricate(:record, user: john, mount: 5000, currency_code: 'VND', update_time: Time.now - 1.hour, updated_at: Time.now - 1.hour, date: Time.now - 1.hour)
    Fabricate(:record, user: john, mount: 10000, currency_code: 'YER', update_time: Time.now - 1.hour, updated_at: Time.now - 1.hour, date: Time.now - 1.hour)
    Fabricate(:record, user: john, mount: 20000, currency_code: 'TWD', update_time: Time.now - 1.hour, updated_at: Time.now - 1.hour, date: Time.now - 1.hour) 
  end

  describe 'test main currency switch' do
    before { visit '/accounts/main_currency' }

    scenario "update to USD" do
      find("#search_box").set 'u'
      find('.flag_america').click
      click_button I18n.t('confirm_edit')
      expect(Currency.find_by('user_id = ? AND sequence_status = ?', john.id, 0).currency_code).to eq('USD')
    end
  end

  after(:each) do
    # check record's amount_to_main
    mainCurrencyRate = Currency.find_by('user_id = ? AND sequence_status = ?', john.id, 0).rate
    Record.where('user_id = ?', john.id).each { |record|
      rate = Currency.find_by("currency_code = ? AND user_id = ?", record.currency_code, john.id).rate
      expect((((record.mount / rate * mainCurrencyRate) * 100)).round / 100.0).to eq(record.amount_to_main.to_f)
    }
  end
end
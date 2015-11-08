require 'spec_helper'

feature "payment", :omniauth  do
  given(:john) { create_user('john@andromoney.com', 'John Doe', 1) }

  background do
    signin(john)
    FileUtils.rm_rf "tmp/cache"
    @record = Fabricate(:record, user_id: john.id, update_time: Time.now - 1.hour, mount: 1000, amount_to_main: 1000, currency_code: 'USD', in_payment: "1")
    Fabricate(:currency, rate: 1.0, currency_code: 'USD', sequence_status: 0)
    Fabricate(:payment, kind: 0, payment_name: "現金", total: 0.00, currency_code: 'USD', rate: 1.000000, hidden: 0 , order_no: 1000, hash_key: "1", user_id: john.id, update_time: "1999-12-31 16:00:00", device_uuid: "computer")
  end

  describe 'test payment cache' do

    scenario "cache enable test" do
      ActionController::Base.perform_caching = true
      visit "/payments"
      expect(page).to have_content('1000.0')
      sql = "Update record_table SET amount_to_main = 2000 where id = #{@record.id} and user_id = #{john.id}"
      ActiveRecord::Base.connection.execute(sql)

      visit "/payments"
      expect(page).to have_content('1000.0')
      sql = "Update record_table SET amount_to_main = 1000 where id = #{@record.id} and user_id = #{john.id}"
      ActiveRecord::Base.connection.execute(sql)
    end

    scenario "cache disable test" do
      ActionController::Base.perform_caching = false
      visit "/payments"
      expect(page).to have_content('1000.0')
      sql = "Update record_table SET amount_to_main = 2000 where id = #{@record.id} and user_id = #{john.id}"
      ActiveRecord::Base.connection.execute(sql)

      visit "/payments"
      expect(page).to have_content('2000.0')
      sql = "Update record_table SET amount_to_main = 1000 where id = #{@record.id} and user_id = #{john.id}"
      ActiveRecord::Base.connection.execute(sql)
    end

    scenario "create record test" do
      ActionController::Base.perform_caching = true
      visit "/payments"
      expect(page).to have_content('1000.0')

      record = Fabricate(:record, user_id: john.id, update_time: Time.now, mount: 111, amount_to_main: 111, currency_code: 'USD', in_payment: "1")

      visit "/payments"
      expect(page).to have_content('1111.0') # total

      record.delete
    end
  end

end
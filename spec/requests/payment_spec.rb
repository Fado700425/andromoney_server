require 'spec_helper'

describe "Payment Cache Test", type: :request do
  before(:all) do
    FileUtils.rm_rf "tmp/cache"
    get 'auth/google_login/callback'
    @record = Fabricate(:record, user_id: session[:user_id], update_time: Time.now - 1.hour, mount: 1000, amount_to_main: 1000, currency_code: 'USD', in_payment: "1")
    Fabricate(:currency, rate: 1.0, currency_code: 'USD', sequence_status: 0)
    Fabricate(:payment, kind: 0, payment_name: "現金", total: 0.00, currency_code: 'USD', rate: 1.000000, hidden: 0 , order_no: 1000, hash_key: "1", user_id: session[:user_id], update_time: "1999-12-31 16:00:00", device_uuid: "computer")
  end

  describe "GET /payment" do
    it "cache enable test" do
      ActionController::Base.perform_caching = true
      get "/payments"
      html = response.body.gsub /[ \n]/, ''
      expect(html).to include '<spanclass=\'remain\'>1000.0</span>'
      sql = "Update record_table SET amount_to_main = 2000 where id = #{@record.id} and user_id = #{session[:user_id]}"
      ActiveRecord::Base.connection.execute(sql)

      get "/payments"
      expect(response.body).to include("USD")
      html = response.body.gsub /[ \n]/, ''
      expect(html).to include '<spanclass=\'remain\'>1000.0</span>'

      sql = "Update record_table SET amount_to_main = 1000 where id = #{@record.id} and user_id = #{session[:user_id]}"
      ActiveRecord::Base.connection.execute(sql)
    end

    it "cache disable test" do
      ActionController::Base.perform_caching = false
      get "/payments"
      html = response.body.gsub /[ \n]/, ''
      expect(html).to include '<spanclass=\'remain\'>1000.0</span>'
      sql = "Update record_table SET amount_to_main = 2000 where id = #{@record.id} and user_id = #{session[:user_id]}"
      ActiveRecord::Base.connection.execute(sql)

      get "/payments"
      expect(response.body).to include("USD")
      html = response.body.gsub /[ \n]/, ''
      expect(html).to include '<spanclass=\'remain\'>2000.0</span>'

      sql = "Update record_table SET amount_to_main = 1000 where id = #{@record.id} and user_id = #{session[:user_id]}"
      ActiveRecord::Base.connection.execute(sql)
    end
    it "create record test" do
      ActionController::Base.perform_caching = true
      get "/payments"
      html = response.body.gsub /[ \n]/, ''
      expect(html).to include '<spanclass=\'remain\'>1000.0</span>'

      record = Fabricate(:record, user_id: session[:user_id], update_time: Time.now, mount: 1000, amount_to_main: 1000, currency_code: 'USD', in_payment: "1")

      get "/payments"
      expect(response.body).to include("USD")
      html = response.body.gsub /[ \n]/, ''
      expect(html).to include '<spanclass=\'remain\'>2000.0</span>'

      record.delete
    end
  end
end
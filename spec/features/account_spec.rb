require 'spec_helper'

feature "account", :omniauth  do
  given(:john) { create_user('john@andromoney.com', 'John Doe', 1) }

  background do
    signin(john)
    Fabricate(:record, user_id: john.id, date: Time.now - 1.hour)
    Fabricate(:category, category: "餐飲食品", type: 20, photo_path: "category_icon/cat_food.gif", hidden: 0, order_no: 1000, hash_key: "1_20", user_id: john.id, update_time: Time.now - 1.hour, updated_at: Time.now - 1.hour)
    Fabricate(:payee, payee_name: "蘋果公司",hidden: 0,type: 0, order_no: 1000, hash_key: "1", user_id: john.id, updated_at: "1999-12-31 16:00:00".to_datetime, update_time: "1999-12-31 16:00:00".to_datetime, device_uuid: "computer")
    Fabricate(:payment, kind: 0, payment_name: "現金", total: 0.00, currency_code: 'TWD', rate: 1.000000, hidden: 0 , order_no: 1000, hash_key: "1", user_id: john.id, updated_at: "1999-12-31 16:00:00".to_datetime, update_time: "1999-12-31 16:00:00".to_datetime, device_uuid: "computer")
    Fabricate(:project, project_name: "商業", hidden: 0, order_no: 1000, hash_key: "1", user_id: john.id, updated_at: "1999-12-31 16:00:00".to_datetime, update_time: "1999-12-31 16:00:00".to_datetime, device_uuid: "computer")
    Fabricate(:currency, currency_code: "AED", rate:3.674140127, currency_remark: "UAE dirham ", sequence_status:-1, flag_path: "UAE.png",user_id: john.id, updated_at: "1999-12-31 16:00:00".to_datetime, update_time: "1999-12-31 16:00:00".to_datetime, device_uuid: "computer")
    Fabricate(:subcategory, id_category: "1_20", subcategory: "早餐",hidden: 0, order_no: 1000,  hash_key: "1_20", user_id: john.id, updated_at: "1999-12-31 16:00:00".to_datetime, update_time: "1999-12-31 16:00:00".to_datetime, device_uuid: "computer")
    Fabricate(:device, user_id: john.id, last_sync_time: Time.now - 3.days, sync_start_time: Time.now)
    Fabricate(:period, user_id: john.id, update_time: Time.now - 1.hour)
    Fabricate(:pref, user_id: john.id, update_time: Time.now - 1.hour)
  end

  describe "delete account" do
    it "check data" do
      visit edit_account_path(1)
      click_button I18n.t('delete')
      click_button I18n.t('confirm')
      expect(Record.where('user_id = ?', john.id).size).to eq(0)
      expect(Category.where('user_id = ?', john.id).size).to eq(0)
      expect(Payee.where('user_id = ?', john.id).size).to eq(0)
      expect(Currency.where('user_id = ?', john.id).size).to eq(0)
      expect(Payment.where('user_id = ?', john.id).size).to eq(0)
      expect(Period.where('user_id = ?', john.id).size).to eq(0)
      expect(Project.where('user_id = ?', john.id).size).to eq(0)
      expect(Pref.where('user_id = ?', john.id).size).to eq(0)
      expect(Subcategory.where('user_id = ?', john.id).size).to eq(0)
      expect(Device.where('user_id = ?', john.id).size).to eq(0)
      expect(Message.where('user_id = ?', john.id).size).to eq(0)
      expect(User.where('id = ?', john.id).size).to eq(0)
    end
  end
end
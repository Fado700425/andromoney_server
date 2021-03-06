require 'spec_helper'

feature 'User shares payment' do
  scenario 'Owner successfully share payment', :vcr do
    bob = Fabricate(:user)
    john = Fabricate(:user)
    share_payment = Fabricate(:payment, user_id: bob.id)

    page.driver.post('/api/v1/sync/owner_share_user_payment', { body: {owner_user: bob.email, share_user: john.email, payment_hash_key: share_payment.hash_key, locale: "zh"}}) 
    page.driver.status_code.should eql 200
    open_email john.email
    current_email.click_link("確認分享")

    expect(UserSharePaymentRelation.count).to eq(1)
    expect(UserSharePaymentRelation.first.is_approved).to be_true
  end
end
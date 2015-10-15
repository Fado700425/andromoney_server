require 'spec_helper'

feature 'Logout', :omniauth, js: true do
	given(:john) { create_user('john@andromoney.com', 'John Doe', 1) }

	background do
		signin(john)
	end

	scenario 'user can log out successfully' do
		expect(page).to have_content(I18n.t('logout'))
		click_link I18n.t('logout')
		expect(page).to have_content('Signed out!')
	end
end
require 'spec_helper'

feature 'Login', :omniauth, js: true do
	given(:john) { create_user('john@andromoney.com', 'John Doe', 1) }

	background do
		signin(john)
	end
	
	scenario 'user can login with a valid account' do
		john.email = 'john@andromoney.com'
		expect(page).to have_content('Signed in!')
		expect(page).to have_content( I18n.t('logout') )
	end 
end
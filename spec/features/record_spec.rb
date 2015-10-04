require 'spec_helper'

feature 'Record', :omniauth, js: true do
	given(:john) { create_user('john@andromoney.com', 'John Doe', 1) }

	background do
		signin(john)
		set_user_assest(john)
	end

	scenario 'new' do
		visit '/records/new'
		
		#set_user_assest(john)
		#expect(page).to have_content('Signed in!')
	end

end

# new expense should have correct category, subcategory, payment, payee, project
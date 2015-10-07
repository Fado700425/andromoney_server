require 'spec_helper'

feature Record, :omniauth, js: true do
	given(:john) { create_user('john@andromoney.com', 'John Doe', 1) }
	
	background do
		signin(john)
		set_user_assest(john)
	end

	given(:tw_account) { Payment.find_by(payment_name: 'Taishin Bank', user_id: john.id) }
	given(:us_account) { Payment.find_by(payment_name: 'Bank of America', user_id: john.id) }
	given(:eu_account) { Payment.find_by(payment_name: 'Deutsch Bank', user_id: john.id) }
	given(:cate_inc)   { Category.find_by(category: 'stock investment', user_id: john.id) }
	given(:cate_out)   { Category.find_by(category: 'Electronics Equ', user_id: john.id) }
	given(:cate_tra)   { Category.find_by(category: 'To my lover', user_id: john.id) }
	given(:subc_inc)   { Subcategory.find_by(subcategory: "Buffet's choice", user_id: john.id) }
	given(:subc_out)   { Subcategory.find_by(subcategory: "Apple's best", user_id: john.id) }
	given(:subc_tra)   { Subcategory.find_by(subcategory: "miss Gina", user_id: john.id) }
	given(:payee)	   { Payee.find_by(payee_name: "Amazon", user_id: john.id)}
	given(:project)	   { Project.find_by(project_name: "Business", user_id: john.id)}

	describe 'New page' do
		before { visit '/records/new' }

		scenario 'users save a record, and get record#new by clicking save_&_add_another_one.' do
			expect { click_button I18n.t('save_and_add_another_one') }.to change(Record, :count).by(1)
			expect(current_path).to eq '/records/new'
			expect(page).to have_content(I18n.t('record.success_create'))
			genernal_content
			expense_title
			expense_content
			new_page_category_toggle
		end

		scenario 'users save a record, and get record#index by clicking save_&_back_to_the_list.' do
			expect { click_button I18n.t('save_and_back_to_the_list') }.to change(Record, :count).by(1)				
			expect(current_path).to eq '/records'
		end

		scenario 'users click "Expense" toggle, and see a expense page.' do
			find('#expenseLink').click
			genernal_content
			expense_title
			expense_content
			new_page_category_toggle
		end

		scenario 'users click "Income" toggle, and see a income page.' do
			find('#incomeLink').click
			genernal_content
			income_title
			income_content
			new_page_category_toggle
		end

		scenario 'users click "Transfer" toggle, and see a transfer page.' do
			find('#transferLink').click
			genernal_content
			transfer_title
			transfer_content
			new_page_category_toggle
		end
	end
end

=begin
describe Record, :omniauth, js: true do
	let(:john) { create_user('john@andromoney.com', 'John Doe', 1) }

	before do
		signin(john)
		set_user_assest(john)
	end

	subject { page }

	shared_examples 'a general new/edit page' do
		it { should have_content(I18n.t('category.main_category')) }
		it { should have_content(I18n.t('subcategory.subcategory')) }
		it { should have_content(I18n.t('project.project')) }
		it { should have_button(I18n.t('save_and_add_another_one')) }
		it { should have_button(I18n.t('save_and_back_to_the_list')) }
	end
	shared_examples 'expense/income page' do
		it { should have_content(I18n.t('payment.payment')) }
		it { should have_content(I18n.t('payee.payee')) }
		it { should_not have_content(I18n.t('transfer.out')) }
		it { should_not have_content(I18n.t('transfer.in')) }
	end
	shared_examples 'transfe page' do
		it { should have_content(I18n.t('transfer.out')) }
		it { should have_content(I18n.t('transfer.in')) }
		it { should_not have_content(I18n.t('payment.payment')) }
		it { should_not have_content(I18n.t('payee.payee')) }
	end
	shared_examples 'a new page with 3 links' do
		it { should have_content(I18n.t('record_type.expense')) }
		it { should have_content(I18n.t('record_type.income')) }
		it { should have_content(I18n.t('record_type.transfer')) }
	end

	describe 'New page' do
		before { visit '/records/new' }

		context 'Default' do
			it_behaves_like 'a general new/edit page'
			it_behaves_like 'expense/income page'
			it_behaves_like 'a new page with 3 links'
		end
	end
end
=end

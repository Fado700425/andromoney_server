module RecordTest
	def genernal_content
		expect(page).to have_content(I18n.t('category.main_category'))
		expect(page).to have_content(I18n.t('subcategory.subcategory'))
		expect(page).to have_content(I18n.t('project.project'))
		expect(page).to have_button(I18n.t('save_and_add_another_one'))
		expect(page).to have_button(I18n.t('save_and_back_to_the_list'))
		expect(page).to have_content(project.project_name)
		expect(page).to have_content(tw_account.payment_name)
	end
	def expense_title
		expect(page).to have_content(I18n.t('payment.payment'))
		expect(page).to have_content(I18n.t('payee.payee'))
		expect(page).not_to have_content(I18n.t('transfer.out'))
		expect(page).not_to have_content(I18n.t('transfer.in'))
	end
	alias_method :income_title, :expense_title
	def transfer_title
		expect(page).to have_content(I18n.t('transfer.out'))
		expect(page).to have_content(I18n.t('transfer.in'))
		#expect(page).not_to have_content(I18n.t('payment.payment'))
		expect(page).not_to have_content(I18n.t('payee.payee'))
	end
	def expense_content
		expect(page).to have_content(cate_out.category)
		expect(page).not_to have_content(cate_inc.category)
		expect(page).not_to have_content(cate_tra.category)
		expect(page).to have_content(payee.payee_name)
	end
	def income_content
		expect(page).not_to have_content(cate_out.category)
		expect(page).to have_content(cate_inc.category)
		expect(page).not_to have_content(cate_tra.category)
		expect(page).to have_content(payee.payee_name)
	end
	def transfer_content
		expect(page).not_to have_content(cate_out.category)
		expect(page).not_to have_content(cate_inc.category)
		expect(page).to have_content(cate_tra.category)
		expect(page).not_to have_content(payee.payee_name)
	end
	def new_page_category_toggle
		expect(page).to have_content(I18n.t('record_type.expense'))
		expect(page).to have_content(I18n.t('record_type.income'))
		expect(page).to have_content(I18n.t('record_type.transfer'))
	end
end
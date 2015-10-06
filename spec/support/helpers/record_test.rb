module RecordTest
	def genernal_content
		expect(page).to have_content(I18n.t('category.main_category'))
		expect(page).to have_content(I18n.t('subcategory.subcategory'))
		expect(page).to have_content(I18n.t('project.project'))
		expect(page).to have_button(I18n.t('save_and_add_another_one'))
		expect(page).to have_button(I18n.t('save_and_back_to_the_list'))
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
		expect(page).not_to have_content(I18n.t('payment.payment'))
		expect(page).not_to have_content(I18n.t('payee.payee'))
	end
	def new_page_link
		expect(page).to have_content(I18n.t('record_type.expense'))
		expect(page).to have_content(I18n.t('record_type.income'))
		expect(page).to have_content(I18n.t('record_type.transfer'))
	end
end
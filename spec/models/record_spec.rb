require 'spec_helper'

describe Record do
	let(:bob) 		  { Fabricate(:user) }
	let(:in_category)     { Fabricate(:category, user_id: bob.id, type: 10) }
	let(:out_category)    { Fabricate(:category, user_id: bob.id, type: 20) }
	let(:tra_category)    { Fabricate(:category, user_id: bob.id, type: 30) }
	let(:in_subcategory)  { Fabricate(:subcategory, user_id: bob.id, id_category: in_category.hash_key) }
	let(:out_subcategory) { Fabricate(:subcategory, user_id: bob.id, id_category: out_category.hash_key) }
	let(:tra_subcategory) { Fabricate(:subcategory, user_id: bob.id, id_category: tra_category.hash_key) }
	let(:deposit) 	  { Fabricate(:payment, user_id: bob.id, currency_code: "TWD") }
	let(:withdrawal)  { Fabricate(:payment, user_id: bob.id, currency_code: "TWD") }
	let(:record) 	  { Fabricate(:record, 	user_id: bob.id, 
											category:      out_category.hash_key, 
											subcategory:   out_subcategory.hash_key,
											out_payment:   withdrawal.hash_key,
											currency_code: withdrawal.currency_code) }	# default as an expense.
	let(:amy) 		  { Fabricate(:user, id: bob.id+1) }
	subject { record }

	describe "as an expense" do
		describe "with out_payment" do
			it { should be_valid }
		end
		describe "with in_payment" do
			before do
				record.in_payment 	 = deposit.hash_key
				record.currency_code = deposit.currency_code
				record.out_payment 	 = nil
			end
			it { should_not be_valid }
		end
		describe "with in_payment & out_payment" do
			before do
				record.out_payment   = withdrawal.hash_key
				record.currency_code = withdrawal.currency_code
				record.in_payment    = deposit.hash_key
			end
			it { should_not be_valid }
		end
		describe "without in_amount/in_currency" do
			it { should be_valid }
		end
		describe "with in_amount/in_currency" do
			before do
				record.in_amount     = 1
				record.in_currency   = "TWD"
			end
			it { should_not be_valid }
		end
	end

	describe "as an income" do
		before do 		#change category/ subcategory
			record.category      = in_category.hash_key
			record.subcategory 	 = in_subcategory.hash_key
			record.out_payment   = nil
			record.currency_code = deposit.currency_code
			record.in_payment    = deposit.hash_key
			record.in_amount     = nil
			record.in_currency   = nil
		end
		describe "with out_payment only" do
			before do
				record.in_payment 	 = nil
				record.out_payment 	 = deposit.hash_key
			end
			it { should_not be_valid }
		end
		describe "with in_payment only" do
			it { should be_valid }
		end
		describe "with in_payment & out_payment" do
			before do
				record.in_payment 	 = deposit.hash_key
				record.out_payment 	 = withdrawal.hash_key
			end
			it { should_not be_valid }
		end
		describe "with in_amount & in_currency" do
			before do
				record.in_amount     = 1
				record.in_currency   = deposit.currency_code
			end
			it { should_not be_valid }
		end
		describe "without in_amount & in_currency" do
			it { should be_valid }
		end
	end

	describe "as a transfer" do
		before do 		#change category/ subcategory
			record.category      = tra_category.hash_key
			record.subcategory 	 = tra_subcategory.hash_key
			record.out_payment   = withdrawal.hash_key
			record.currency_code = withdrawal.currency_code
			record.in_payment    = deposit.hash_key
			record.in_amount     = 1
			record.in_currency   = deposit.currency_code
		end
		describe "with out_payment only" do
			before do
				record.in_payment 	 = nil
				record.currency_code = nil
				record.out_payment 	 = deposit.hash_key
			end
			it { should_not be_valid }
		end
		describe "with in_payment only" do
			before do
				record.in_payment 	 = deposit.hash_key
				record.currency_code = deposit.currency_code
				record.out_payment 	 = nil
			end
			it { should_not be_valid }
		end
		describe "with in_payment & out_payment" do
			it { should be_valid }
		end
		describe "with in_amount & in_currency" do
			it { should be_valid }
		end
		describe "without in_amount & in_currency" do
			before do
				record.in_amount     = nil
				record.in_currency   = nil
			end
			it { should_not be_valid }
		end

		describe "with the same in_payment & out_payment" do
			before do
				record.out_payment = record.in_payment
			end
			it { should_not be_valid }
		end
	end

	describe "with category from other user" do
		let(:category_from_other_user) { Fabricate(:category, user_id: amy.id) }
		before { record.category = category_from_other_user.hash_key }
		it { should_not be_valid }
	end

	describe "with subcategory not belongs to category" do
		let(:subcategory_from_different_category) { Fabricate(:subcategory, user_id: bob.id, id_category: "another_category_key") }
		before { record.subcategory = subcategory_from_different_category.hash_key }
    	it { should_not be_valid }
	end

	describe "without mount" do
		before { record.mount = nil }
    	it { should_not be_valid }
	end
	describe "without category" do
		before { record.category = nil }
    	it { should_not be_valid }
	end
	describe "without subcategory" do
		before { record.subcategory = nil }
    	it { should_not be_valid }
	end
	describe "without date" do
		before { record.date = nil }
    	it { should_not be_valid }
	end
	describe "without currency_code" do
		before { record.currency_code = nil }
    	it { should_not be_valid }
	end
	describe "without user_id" do
		before { record.user_id = nil }
    	it { should_not be_valid }
	end

	describe "of the same user" do
		it "with a duplicate hash_key." do
			record.save!
			another_record = record.dup 		#copy record to @another_record
			another_record.valid?
			expect(another_record.errors[:hash_key]).to include("has already been taken")
		end
	end

end
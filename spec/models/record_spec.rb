require 'spec_helper'

describe Record do
	let(:bob) 		  { Fabricate(:user) }
	let(:category)    { Fabricate(:category, user_id: bob.id) }
	let(:subcategory) { Fabricate(:subcategory, user_id: bob.id, id_category: category.hash_key) }
	let(:deposit) 	  { Fabricate(:payment, user_id: bob.id, currency_code: "TWD") }
	let(:withdrawal)  { Fabricate(:payment, user_id: bob.id, currency_code: "TWD") }
	let(:record) 	  { Fabricate(:record, 	user_id: bob.id, 
										category: category.hash_key, 
										subcategory: subcategory.hash_key,
										out_payment: withdrawal.hash_key,
										currency_code: withdrawal.currency_code) }	# set as an expense.
	subject { record }

	describe "as an expense" do
		it { should be_valid }
		it "category type is 20" do
			pending
		end
		it "subcategory belongs to category" do
			pending
		end
	end

	describe "as an income" do
		before do
			record.in_payment = deposit.hash_key
			record.currency_code = deposit.currency_code
			record.out_payment = nil
		end

		it { should be_valid }
	end

	describe "as a transfer" do
		before do
			record.out_payment   = withdrawal.hash_key
			record.currency_code = withdrawal.currency_code
			record.in_payment    = deposit.hash_key
			record.in_currency   = deposit.currency_code
			#record.in_amount     = 0
		end

		it { should be_valid }
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
	describe "without amount_to_main" do
		pending
	end
	describe "without user_id" do
		before { record.user_id = nil }
    	it { should_not be_valid }
	end

	describe "of different users" do
		it "is valid with a duplicate hash_key." do
			record.save!
			another_record = record.dup 				#copy record to @another_record
			another_record.user_id = record.user_id+1	#set for different users.
			expect(another_record).to be_valid
		end
	end
	describe "of the same user" do
		it "is invalid with a duplicate hash_key." do
			record.save!
			another_record = record.dup 		#copy record to @another_record
			another_record.valid?
			expect(another_record.errors[:hash_key]).to include("has already been taken")
		end
	end

end
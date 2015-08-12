require 'spec_helper'

describe Record do
	before do
		@record = Record.new( mount: 0, category: 'fdWS92Sv3d9iSiSd3H7INg', sub_category: 'gB9O7LgZjh1Qe7T0pQVKBw',
					      	  date: '2015-07-29 23:37:00', currency_code: 'TWD', amount_to_main: 0, user_id: 2,
						  	  hash_key: 'C2OSs1kB7RDkqsKPR3SR2A', in_payment: 'rFzafXEQ4mVbumzVSBq1SQ')
  	end


	it "is valid with mount, category, sub_category, date, currency_code, amount_to_main, user_id, hash_key and in_payment (or out_payment)." do
		expect(@record).to be_valid
	end

	it "is valid with mount, category, sub_category, date, currency_code, amount_to_main, user_id, hash_key and out_payment (or in_payment)." do
		@record.in_payment = nil
		@record.out_payment = '0PUUHLJ8ZPtd3jgSxEJIbA'
		expect(@record).to be_valid 
	end

	it "is invalid without a mount." do
		@record.mount = nil
		@record.valid?
		expect(@record.errors[:mount]).to include("can't be blank")
	end

	it "is invalid without a category."
	it "is invalid without a sub_category."
	it "is invalid without a date."
	it "is invalid without a currency_code."
	it "is invalid without a amount_to_main."
	it "is invalid without a user_id."
	it "is invalid without a (in_payment or out_payment)."

	describe "of the same user" do
		it "is invalid with a duplicate hash_key." do
			@record.save!
			@another_record = @record.dup 		#copy @record to @another_record
			@another_record.valid?
			expect(@another_record.errors[:hash_key]).to include("has already been taken")
		end
	end

	describe "of different users" do
		it "is valid with a duplicate hash_key." do
			@record.save!
			@another_record = @record.dup 				#copy @record to @another_record
			@another_record.user_id = @record.user_id+1	#set for different users.
			expect(@another_record).to be_valid
		end
	end


end
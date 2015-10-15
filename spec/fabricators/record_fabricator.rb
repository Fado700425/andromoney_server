Fabricator(:record) do
	transient user_id: nil
	mount { Faker::Number.between(100, 10000) }
	amount_to_main { Faker::Number.between(100, 10000) }
	user { |attrs| attrs[:user_id].nil? ? nil: User.find(attrs[:user_id]) }
	date { Time.zone.today + (Faker::Number.between(-20, 20) * -1).days + (Faker::Number.between(0, 23)).hours }
	hash_key { Faker::Lorem.characters(20) }
	is_delete 0
	device_uuid { Faker::Lorem.characters(20) }
	#category		{ Faker::Lorem.characters(20) }
	#subcategory	{ Faker::Lorem.characters(20) }
	#in_payment		
	#out_payment
	#currency_code	
	#amount_to_main
	#in_amount
	#in_currency
end
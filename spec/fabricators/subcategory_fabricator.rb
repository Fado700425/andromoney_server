Fabricator(:subcategory) do
	transient user_id: nil
	user { |attrs| attrs[:user_id].nil?? nil: User.find(attrs[:user_id]) }
	hash_key 		{ Faker::Lorem.characters(20) }
	device_uuid 	{ Faker::Lorem.characters(20) }
	subcategory 	{ Faker::Lorem.characters(5) }
	is_delete		false
	hidden 			0
	order_no		{ Faker::Number.between(1, 100) }
	update_time 	Time.zone.now
	#id_category
end
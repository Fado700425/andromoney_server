Fabricator(:subcategory) do
  transient user_id: nil
  user { |attrs| attrs[:user_id].nil?? nil: User.find(attrs[:user_id]) }
  hash_key { Faker::Lorem.characters(20) }
  is_delete false
  device_uuid { Faker::Lorem.characters(20) }
  subcategory { Faker::Lorem.characters(20) }
  hidden 0
  update_time Time.zone.now
end
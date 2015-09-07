Fabricator(:record) do
  transient user_id: nil
  mount { Faker::Number.between(100, 10000) }
  amount_to_main { Faker::Number.between(100, 10000) }
  user { |attrs| attrs[:user_id].nil?? nil: User.find(attrs[:user_id]) }
  date { Time.zone.today + (Faker::Number.between(-20, 20) * -1).days + (Faker::Number.between(0, 23)).hours }
  hash_key { Faker::Lorem.characters(20) }
  is_delete false
  device_uuid { Faker::Lorem.characters(20) }
end
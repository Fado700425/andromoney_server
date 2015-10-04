Fabricator(:payment) do
  transient user_id: nil
  user { |attrs| attrs[:user_id].nil?? nil: User.find(attrs[:user_id]) }
  hash_key {Faker::Lorem.characters(20)}
  device_uuid {Faker::Lorem.characters(20)}
  payment_name {Faker::Lorem.characters(5)}
  kind 0
  total 100
  is_delete false
  hidden 0
  update_time Time.now
end
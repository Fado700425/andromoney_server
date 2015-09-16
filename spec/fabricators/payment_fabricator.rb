Fabricator(:payment) do
  transient user_id: nil
  user { |attrs| attrs[:user_id].nil?? nil: User.find(attrs[:user_id]) }
  hash_key {Faker::Lorem.characters(20)}
  is_delete false
  device_uuid {Faker::Lorem.characters(20)}
  payment_name {Faker::Lorem.characters(5)}
  kind 1
  total 100
  hidden false
  update_time Time.now
end
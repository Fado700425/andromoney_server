Fabricator(:payee) do
  hash_key {Faker::Lorem.characters(20)}
  is_delete false
  device_uuid {Faker::Lorem.characters(20)}
  payee_name {Faker::Lorem.characters(20)}
  hidden 1
  type 1
  order_no 1
  update_time Time.now
end
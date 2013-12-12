Fabricator(:period) do
  hash_key {Faker::Lorem.characters(20)}
  is_delete false
  device_uuid {Faker::Lorem.characters(20)}
  start_date Time.now
  period_type 1
  period_num 1
  update_time Time.now
end
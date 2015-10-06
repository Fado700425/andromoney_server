Fabricator(:project) do
  hash_key {Faker::Lorem.characters(20)}
  device_uuid {Faker::Lorem.characters(20)}
  project_name {Faker::Lorem.characters(20)}
  hidden 0
  is_delete false
  order_no { Faker::Number.between(1, 100) }
  update_time Time.now
end
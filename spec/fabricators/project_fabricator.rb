Fabricator(:project) do
  hash_key {Faker::Lorem.characters(20)}
  is_delete false
  device_uuid {Faker::Lorem.characters(20)}
  project_name {Faker::Lorem.characters(20)}
  hidden 1
  update_time Time.now
end
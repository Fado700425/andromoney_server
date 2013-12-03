Fabricator(:category) do
  hash_key {Faker::Lorem.characters(20)}
  is_delete false
  device_uuid {Faker::Lorem.characters(20)}
  category {Faker::Lorem.characters(5)}
  type 1
  photo_path {Faker::Lorem.characters(5)}
  hidden 1
  update_time Time.now
end
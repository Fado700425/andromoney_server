Fabricator(:currency) do
  currency_code {Faker::Lorem.characters(3)}
  is_delete false
  device_uuid {Faker::Lorem.characters(20)}
  rate 3
  sequence_status 3
  flag_path {Faker::Lorem.characters(20)}
  update_time Time.now
end
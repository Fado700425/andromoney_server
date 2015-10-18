Fabricator(:currency) do
  user { |attrs| attrs[:user_id].nil? ? nil: User.find(attrs[:user_id]) }
  currency_code {Faker::Lorem.characters(3)}
  is_delete false
  device_uuid {Faker::Lorem.characters(20)}
  rate 3
  sequence_status 0
  flag_path {Faker::Lorem.characters(20)}
  update_time Time.now
end
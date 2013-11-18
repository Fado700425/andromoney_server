Fabricator(:currency) do
  currency_code {Faker::Lorem.characters(3)}
  is_delete false
  device_uuid {Faker::Lorem.characters(20)}
end
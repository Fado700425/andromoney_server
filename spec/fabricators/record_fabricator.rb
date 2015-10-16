Fabricator(:record) do
  mount { Faker::Number.between(100, 10000) }
  amount_to_main { Faker::Number.between(100, 10000) }
  date { Time.zone.today + (Faker::Number.between(-20, 20) * -1).days + (Faker::Number.between(0, 23)).hours }
  hash_key { Faker::Lorem.characters(20) }
  is_delete false
  remark { Faker::Lorem.paragraph(sentence_count=7) }
  device_uuid { Faker::Lorem.characters(20) }
end
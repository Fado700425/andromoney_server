Fabricator(:project) do
  hash_key {Faker::Lorem.characters(20)}
  is_delete false
end
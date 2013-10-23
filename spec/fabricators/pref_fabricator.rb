Fabricator(:pref) do
  key {Faker::Lorem.characters(20)}
  is_delete false
end
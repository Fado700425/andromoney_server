Fabricator(:currency) do
  currency_code {Faker::Lorem.characters(3)}
  is_delete false
end
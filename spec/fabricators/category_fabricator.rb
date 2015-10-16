Fabricator(:category) do
  hash_key { Faker::Lorem.characters(20) }
  is_delete false
  device_uuid { Faker::Lorem.characters(20) }
  category { Faker::Lorem.characters(5) }
  type 1
  photo_path { "category_icon/#{Dir.entries(Rails.root.join('app', 'assets', 'images', 'category_icon').to_s).select { |x| x != '.' && x != '..' }.sample}" }
  hidden 0
  update_time Time.zone.now
end
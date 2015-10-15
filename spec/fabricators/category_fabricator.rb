Fabricator(:category) do
  transient user_id: nil
  user { |attrs| attrs[:user_id].nil? ? nil : User.find(attrs[:user_id]) }
  hash_key { Faker::Lorem.characters(20) }
  device_uuid { Faker::Lorem.characters(20) }
  category { Faker::Lorem.characters(5) }
  type 20
  photo_path { "category_icon/#{Dir.entries(Rails.root.join('app', 'assets', 'images', 'category_icon').to_s).select { |x| x != '.' && x != '..' }.sample}" }
  hidden 0
  is_delete false
  update_time Time.zone.now
  order_no	{ Faker::Number.between(1, 100) }
end

#income:   type = 10
#expense:  type = 20
#transfer: type = 30

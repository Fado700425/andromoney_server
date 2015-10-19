require 'sidekiq/web'
Sidekiq::Web.use(Rack::Auth::Basic) do |user, password|
  [user, password] == [ENV['SIDEKIQ_ID'], ENV['SIDEKIQ_PW']]
end

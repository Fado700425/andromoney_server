# This file is copied to spec/ when you run 'rails generate rspec:install'
ENV["RAILS_ENV"] ||= 'test'
require File.expand_path("../../config/environment", __FILE__)

require 'rspec/rails'

require 'capybara/rails'
require 'capybara/rspec'
require 'capybara/email/rspec'

require 'vcr'

#require 'capybara/poltergeist'
#Capybara.javascript_driver = :poltergeist
#Capybara.javascript_driver = :webkit

require 'sidekiq/testing'
Sidekiq::Testing.inline!



Dir[Rails.root.join("spec/support/**/*.rb")].each { |f| require f }

ActiveRecord::Migration.check_pending! if defined?(ActiveRecord::Migration)

VCR.configure do |c|
  c.cassette_library_dir = 'spec/cassettes'
  c.hook_into :webmock
  c.configure_rspec_metadata!
  c.ignore_localhost = true
end

RSpec.configure do |config|
  # config.include FactoryGirl::Syntax::Methods

  config.fixture_path = "#{::Rails.root}/spec/fixtures"
  config.infer_spec_type_from_file_location!

  config.use_transactional_fixtures = false
  config.infer_base_class_for_anonymous_controllers = false
  config.order = "random"

  # omniauth
  config.include Omniauth::Mock
  config.include Omniauth::SessionHelpers, type: :feature
  config.include NewTestUser, type: :feature
  config.include RecordTest, type: :feature
  #config.include Capybara::DSL

  config.before(:suite) do
    #DatabaseCleaner.strategy = :transaction
    DatabaseCleaner.strategy = :truncation
    DatabaseCleaner.clean_with(:truncation)
  end

  config.before(:each) do
    DatabaseCleaner.start
  end

  config.after(:each) do
    DatabaseCleaner.clean
  end

end
OmniAuth.config.test_mode = true

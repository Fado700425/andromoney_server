namespace :dev do

  desc "Rebuild system"
  task :build => %w(tmp:clear log:clear db:drop db:create db:migrate db:seed db:test:prepare)

  desc "generate dev seed"
  task :import_sample => :environment do
    Rake::Task["db:reset"].invoke
    load File.join(pwd,'lib','sample.rb')
  end
end
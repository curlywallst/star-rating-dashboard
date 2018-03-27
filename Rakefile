# Add your own tasks in files placed in lib/tasks ending in .rake,
# for example lib/tasks/capistrano.rake, and they will automatically be available to Rake.

require_relative 'config/application'

Rails.application.load_tasks

task :drop_and_migrate do
    puts "Dropping Database..."
    system("rake db:drop")
    puts "creating databse and migrating..."
    system("rake db:create db:migrate")
    puts "seeding database"
    system("rake db:seed")
end
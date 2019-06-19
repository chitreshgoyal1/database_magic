# lib/tasks/database.rake
namespace :database do

  desc "Dumps the database to db/application_name.dump"
  task :dump => :environment do
    cmd = nil
    get_config_from_database_yml do |app, host, db, user|
      cmd = "pg_dump --host #{host} --username #{user} --verbose --clean --no-owner --no-acl --format=c #{db} > #{Rails.root}/db/#{app}.dump"
    end
    puts cmd
    exec cmd
  end

  desc "Restore database dump at db/application_name.dump."
  task :restore => :environment do
    cmd = nil
    get_config_from_database_yml do |app, host, db, user|
      cmd = "pg_restore --verbose --host #{host} --username #{user} --clean --no-owner --no-acl --dbname #{db} #{Rails.root}/db/#{app}.dump"
    end
    Rake::Task["db:drop"].invoke
    Rake::Task["db:create"].invoke
    puts cmd
    exec cmd
  end

  private

  def get_config_from_database_yml
    yield Rails.application.class.parent_name.underscore,
      ActiveRecord::Base.connection_config[:host],
      ActiveRecord::Base.connection_config[:database],
      ActiveRecord::Base.connection_config[:username]
  end

end

=begin
HowToUse.sh
  # To dump development database
  rake db:dump

  # To dump production database
  RAILS_ENV=production rake db:dump

  # dump the production database & restore it to the development database
  RAILS_ENV=production rake db:dump
  rake db:restore

  # For database configuration database.yml is used
  # This script works for postgres database only
  # For different databases use gem "seed_dump"
  
  # note: config/database.yml is used for database configuration,
  #       but you will be prompted for the database user's password
=end







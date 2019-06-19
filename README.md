# database_magic
Dump &amp; Restore DB

1. Dump & Restore PG data without options
2. Dump & Restore PG data with options

  
    Sample Script
      # lib/tasks/database.rake
      namespace :database do

        def dump_path
          Rails.root.join('db/dump.psql').to_path
        end

        def db_name
          config = Rails.configuration.database_configuration[Rails.env]
          "postgresql://#{config['username']}:#{config['password']}@127.0.0.1:5432/#{config['database']}"
        end

        task :dump do
          system "pg_dump -Fc --no-owner --dbname=#{db_name} > #{dump_path}"
        end

        task :load do
          system "pg_restore --clean --no-owner --dbname=#{db_name} #{dump_path}"
        end

      end

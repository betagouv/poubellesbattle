def dump_path
  Rails.root.join('db/dump.psql').to_path
end

namespace :batch do
  desc 'db_dump dumps with pg_dump'
  task :db_dump do
    system "pg_dump -Fc --no-owner --dbname=#{ENV['DATABASE_URL']} > #{dump_path}"
  end
end

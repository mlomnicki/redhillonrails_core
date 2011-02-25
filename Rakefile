require 'bundler'
Bundler::GemHelper.install_tasks

require 'rspec/core/rake_task'
%w[postgresql mysql mysql2 sqlite3].each do |adapter|
  namespace adapter do
    RSpec::Core::RakeTask.new(:spec) do |spec|
      spec.rspec_opts = "-Ispec/connections/#{adapter}"
    end
  end
end

desc 'Run postgresql and mysql tests'
task :spec do
  %w[postgresql mysql mysql2 sqlite3].each do |adapter|
    Rake::Task["#{adapter}:spec"].invoke
  end
end

task :default => :spec

namespace :postgresql do
  desc 'Build the PostgreSQL test databases'
  task :build_databases do
    %x( createdb -E UTF8 rh_core_unittest )
  end

  desc 'Drop the PostgreSQL test databases'
  task :drop_databases do
    %x( dropdb rh_core_unittest )
  end

  desc 'Rebuild the PostgreSQL test databases'
  task :rebuild_databases => [:drop_databases, :build_databases]
end

task :build_postgresql_databases => 'postgresql:build_databases'
task :drop_postgresql_databases => 'postgresql:drop_databases'
task :rebuild_postgresql_databases => 'postgresql:rebuild_databases'

MYSQL_DB_USER = 'rh_core'
namespace :mysql do
  desc 'Build the MySQL test databases'
  task :build_databases do
    %x( echo "create DATABASE rh_core_unittest DEFAULT CHARACTER SET utf8 DEFAULT COLLATE utf8_unicode_ci " | mysql --user=#{MYSQL_DB_USER})
  end

  desc 'Drop the MySQL test databases'
  task :drop_databases do
    %x( mysqladmin --user=#{MYSQL_DB_USER} -f drop rh_core_unittest )
  end

  desc 'Rebuild the MySQL test databases'
  task :rebuild_databases => [:drop_databases, :build_databases]
end

task :build_mysql_databases => 'mysql:build_databases'
task :drop_mysql_databases => 'mysql:drop_databases'
task :rebuild_mysql_databases => 'mysql:rebuild_databases'

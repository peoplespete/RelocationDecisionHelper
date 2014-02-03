#!/usr/bin/env ruby
# -*- ruby -*-

require_relative 'lib/environment'
require 'rake/testtask'

Rake::TestTask.new() do |t|
  t.pattern = "test/test_*.rb"
end

desc "Run tests"
task :default => :test

desc 'create the production database setup'
task :bootstrap_database do
  Environment.environment = "production"
  database = Environment.database_connection
  create_tables(database)
end

desc 'prepare the test database'
task :test_prepare do
  # File.delete("db/relocator_test.sqlite3")
  Environment.environment = "test"
  database = Environment.database_connection
  create_tables(database)
end

def create_tables(database_connection)
  database_connection.execute("CREATE TABLE locations (id INTEGER PRIMARY KEY AUTOINCREMENT, city varchar(50), state_code varchar(2), climate varchar(50), employment_outlook text, cost_of_living integer, notes text)")
  # database_connection.execute("CREATE TABLE categories (id INTEGER PRIMARY KEY AUTOINCREMENT, name varchar(50))")
end

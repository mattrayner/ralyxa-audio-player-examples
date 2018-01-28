require 'data_mapper'

# If you want the logs displayed you have to do this before the call to setup
DataMapper::Logger.new($stdout, :debug)

# An in-memory Sqlite3 connection:
# DataMapper.setup(:default, 'sqlite::memory:')
database_url = ENV['DATABASE_URL'] || "sqlite3://#{Dir.pwd}/development.db"
DataMapper.setup(:default, database_url)

require_relative '../models/user'

DataMapper.finalize
DataMapper.auto_migrate!

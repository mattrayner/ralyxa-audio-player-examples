# A simple class that holds the last time a jingle was played for a given user.
class User
  include DataMapper::Resource

  property :id,        Serial # An auto-increment integer key
  property :user_id,   Text
  property :played_at, Time   # A DateTime, for any date you might like.
end
# A simple class that holds the attributes of a user
class User
  include DataMapper::Resource

  property :id,                Serial
  property :user_id,           String, length: 255, required: true
  property :player_attributes, Json,   lazy: false
end

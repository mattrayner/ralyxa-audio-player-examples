require 'sinatra'
require 'ralyxa'
require './config/audio_data'
require './config/datamapper_config'
require './helpers/jingle_helper'

post '/' do
  Ralyxa::Skill.handle(request)
end


require 'sinatra'
require 'ralyxa'
require './config/audio_data'
require './config/datamapper_config'
require './helpers/attributes_helper'

post '/' do
  Ralyxa::Skill.handle(request)
end

require 'irb'; binding.irb
intent 'PlayAudio' do
  log('I', request.intent_name)

  attributes = AttributesHelper.new({})
  puts 'a'
  user = User.first_or_create(user_id: request.user_id)
  user.update!(player_attributes: attributes.to_hash)

  episode = AudioData::STREAMS[attributes.play_order[attributes.index]]
  audio_source = episode[:url]

  respond(
    "Playing #{episode[:title]}",
    directives: [audio_player.play(audio_source, attributes.index)],
    end_session: true
  )
end

intent 'AMAZON.ResumeIntent' do
  log('I', request.intent_name)

  user = User.first(user_id: request.user_id)

  attributes = AttributesHelper.new(user.player_attributes)

  episode = AudioData::STREAMS[attributes.play_order[attributes.index]]

  respond(
    '',
    directives: [audio_player.play(episode[:url], attributes.index, offset_in_milliseconds: attributes.offset_in_milliseconds)],
    end_session: true
  )
end

intent 'AMAZON.PauseIntent' do
  log('I', request.intent_name)

  respond(
    '',
    directives:  [audio_player.stop],
    end_session: true
  )
end

intent 'AMAZON.StopIntent' do
  log('I', request.intent_name)

  respond(
    '',
    directives:  [audio_player.stop],
    end_session: true
  )
end

intent 'AMAZON.LoopOnIntent' do
  log('I', request.intent_name)

  user = User.first_or_create(user_id: request.user_id)

  attributes = AttributesHelper.new(user.player_attributes)
  attributes.loop = true

  user.player_attributes = attributes.to_json
  user.save

  respond(
    'Loop mode on',
    end_session: true
  )
end

intent 'AMAZON.LoopOffIntent' do
  log('I', request.intent_name)

  user = User.first_or_create(user_id: request.user_id)

  attributes = AttributesHelper.new(user.player_attributes)
  attributes.loop = false

  user.player_attributes = attributes.to_json
  user.save

  respond(
    'Loop mode off',
    session_attributes: session_attributes.to_hash,
    end_session: true
  )
end

intent 'AMAZON.ShuffleOnIntent' do
  log('I', request.intent_name)

  user = User.first_or_create(user_id: request.user_id)

  attributes = AttributesHelper.new(user.player_attributes)
  attributes.shuffle = true
  attributes.play_order = AttributesHelper.shuffled_play_order
  attributes.index = 0
  attributes.offset_in_milliseconds = 0

  user.player_attributes = attributes.to_json
  user.save

  episode = AudioData::STREAMS[attributes.play_order[attributes.index]]

  respond(
    'Shuffle mode on',
    directives: [audio_player.play(episode[:url], attributes.index)],
    end_session: true
  )
end

intent 'AMAZON.ShuffleOffIntent' do
  log('I', request.intent_name)

  user = User.first_or_create(user_id: request.user_id)

  attributes = AttributesHelper.new(user.player_attributes)
  attributes.shuffle = false
  attributes.play_order = AttributesHelper.standard_play_order
  attributes.index = 0
  attributes.offset_in_milliseconds = 0

  user.player_attributes = attributes.to_json
  user.save

  episode = AudioData::STREAMS[attributes.play_order[attributes.index]]

  respond(
    'Shuffle mode off',
    directives: [audio_player.play(episode[:url], attributes.index)],
    end_session: true
  )
end

intent 'AMAZON.StartOverIntent' do
  log('I', request.intent_name)

  user = User.first_or_create(user_id: request.user_id)

  attributes = AttributesHelper.new(user.player_attributes)
  attributes.offset_in_milliseconds = 0

  user.player_attributes = attributes.to_json
  user.save

  episode = AudioData::STREAMS[attributes.play_order[attributes.index]]

  respond(
    "Re-starting #{episode[:title]}",
    directives: [audio_player.play(episode[:url], attributes.index)],
    end_session: true
  )
end

intent 'AMAZON.NextIntent' do
  log('I', request.intent_name)

  user = User.first_or_create(user_id: request.user_id)

  attributes = AttributesHelper.new(user.player_attributes)

  current_episode_index = attributes.index

  next_episode_index = current_episode_index + 1

  if next_episode_index >= attributes.play_order.length
    next_episode_index = 0 if attributes.loop

    return respond("You've reached the end of the playlist. Say 'Alexa, Stop' to stop now.", end_session: true) unless attributes.loop
  end

  episode = AudioData::STREAMS[attributes.play_order[next_episode_index]]
  attributes.index = next_episode_index

  user.player_attributes = attributes.to_json
  user.save

  respond(
    nil,
    directives: [audio_player.play(episode[:url], next_episode_index)],
    end_session: true
  )
end

intent 'AMAZON.PreviousIntent' do
  log('I', request.intent_name)

  user = User.first_or_create(user_id: request.user_id)

  attributes = AttributesHelper.new(user.player_attributes)

  current_episode_index = attributes.index

  next_episode_index = current_episode_index - 1

  if next_episode_index < 0
    next_episode_index = attributes.play_order.length - 1 if attributes.loop

    return respond("You've reached the start of the playlist. Say 'Alexa, Restart' to start the episode from the beginning.", end_session: true) unless attributes.loop
  end

  episode = AudioData::STREAMS[attributes.play_order[next_episode_index]]
  attributes.index = next_episode_index

  user.player_attributes = attributes.to_json
  user.save

  respond(
    nil,
    directives: [audio_player.play(episode[:url], next_episode_index)],
    end_session: true
  )
end

intent 'SessionEndedRequest' do
  log('I', request.intent_name)

  respond
end

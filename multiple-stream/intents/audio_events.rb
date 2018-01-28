intent 'AudioPlayer.PlaybackStarted' do
  log('I', request.intent_name)

  user = User.first_or_create(user_id: request.user_id)
  attributes = AttributesHelper.new(user.player_attributes)

  token = request.request.dig('request', 'token')
  attributes.index = attributes.play_order.index(token.to_i) unless token.nil?

  user.player_attributes = attributes.to_hash
  user.save

  respond(
    nil,
    end_session: true
  )
end

intent 'AudioPlayer.PlaybackFinished' do
  log('I', request.intent_name)

  respond(
    nil,
    end_session: true
  )
end

intent 'AudioPlayer.PlaybackNearlyFinished' do
  log('I', request.intent_name)

  user = User.first_or_create(user_id: request.user_id)
  attributes = AttributesHelper.new(user.player_attributes)

  current_episode_index = attributes.index
  next_episode_index = current_episode_index + 1

  if next_episode_index >= attributes.play_order.length
    next_episode_index = 0 if attributes.loop

    return respond(nil, end_session: true) unless attributes.loop
  end

  episode = AudioData::STREAMS[attributes.play_order[next_episode_index]]

  respond(
    nil,
    directives: [audio_player.play_later(episode[:url], next_episode_index)],
    end_session: true
  )
end

intent 'AudioPlayer.PlaybackStopped' do
  log('I', request.intent_name)

  user = User.first_or_create({ user_id: request.user_id })

  attributes = AttributesHelper.new(user.player_attributes)
  attributes.offset_in_milliseconds = request.request['offsetInMilliseconds'] || 0

  user.player_attributes = attributes.to_json
  user.save

  respond(
    nil,
    end_session: true
  )
end

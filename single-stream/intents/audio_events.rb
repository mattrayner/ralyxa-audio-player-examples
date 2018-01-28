intent 'AudioPlayer.PlaybackStarted' do
  log('I', request.intent_name)

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

  audio_player_directive = audio_player.play_later(
    AudioData::STREAM_URL,
    AudioData::STREAM_URL
  )

  respond(
    nil,
    directives: [audio_player_directive],
    end_session: true
  )
end

intent 'AudioPlayer.PlaybackStopped' do
  log('I', request.intent_name)

  respond(
    nil,
    end_session: true
  )
end

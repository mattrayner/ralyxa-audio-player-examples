intent 'PlayAudio' do
  log('I', request.intent_name)

  if JingleHelper.play?(request.user_id)
    audio_source = AudioData::JINGLE_URL
    JingleHelper.update_timestamp(request.user_id)
  else
    audio_source = AudioData::STREAM_URL
  end

  standard_card = card(
    AudioData::CARD[:title],
    AudioData::CARD[:content],
    AudioData::CARD[:image]
  )

  respond(
    '',
    directives: [audio_player.play(audio_source, audio_source)],
    end_session: true,
    card: standard_card
  )
end

intent 'AMAZON.ResumeIntent' do
  log('I', request.intent_name)

  respond(
    '',
    directives: [audio_player.play(AudioData::STREAM_URL, AudioData::STREAM_URL)],
    end_session: true
  )
end

intent 'AMAZON.PauseIntent' do
  log('I', request.intent_name)

  respond(
    '',
    directives: [audio_player.stop],
    end_session: true
  )
end

intent 'AMAZON.StopIntent' do
  log('I', request.intent_name)

  respond(
    '',
    directives: [audio_player.stop],
    end_session: true
  )
end

intent 'SessionEndedRequest' do
  log('I', request.intent_name)

  respond
end

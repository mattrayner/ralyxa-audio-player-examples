intent 'System.ExceptionEncountered' do
  log('E', request.intent_name)

  request_body = request.instance_variable_get(:@request)
  puts request_body['request']['error']
  puts request_body['request']['cause']
end

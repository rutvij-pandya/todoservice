require 'json'

def event_body(event)
  JSON.parse(event['body'])
end

def params_id(event)
  event['pathParameters']['id']
end


require_relative '../lib/event_parser'
require_relative '../lib/crud'

def get(event:, context:)
  begin
    puts "Received Request: #{event}"
    result = find_record(ENV['DYNAMODB_TABLE'], params_id(event))
    
    { statusCode: 200, body: JSON.generate(todo: result['item'])}
  rescue StandardError => e  
    puts e.message  
    puts e.backtrace.inspect  
    { statusCode: 400, body: JSON.generate("Bad request, Error - #{e.message}") }
  end
end
require_relative '../lib/event_parser'
require_relative '../lib/crud'

def create(event:, context:)
  begin
    puts "Received Request: #{event}"
    data = build_item_data(event_body(event))
    result = create_record(ENV['DYNAMODB_TABLE'], data)

    { statusCode: 200, body: JSON.generate(success: true, todo: result) }
  rescue StandardError => e  
    puts e.message  
    puts e.backtrace.inspect  
    { statusCode: 400, body: JSON.generate("Bad request, Error - #{e.message}") }
  end
end

def build_item_data(params)
  {
    id: SecureRandom.hex(10),
    task: params['task'],
    checked: false
  }
end

require_relative '../lib/event_parser'
require_relative '../lib/crud'

def update(event:, context:)
  begin
    puts "Received Request: #{event}"
    data = build_item_data(event_body(event))
    result = update_record(ENV['DYNAMODB_TABLE'], params_id(event), data)

    { statusCode: 200, body: JSON.generate(success: true, todo: result['attributes']) }
  rescue StandardError => e  
    puts e.message  
    puts e.backtrace.inspect  
    { statusCode: 400, body: JSON.generate("Bad request, Error - #{e.message}") }
  end
end

def build_item_data(params)
  timestamp = Time.now.to_i

  {
    update_expression: 'set task = :task, checked = :checked, updatedAt = :updatedAt',
    expression_attribute_values: {
      ':task' => params['task'],
      ':checked' => params['checked'],
      ':updatedAt' => timestamp
    }
  }
end
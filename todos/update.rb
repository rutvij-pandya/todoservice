require 'json'
require 'aws-sdk-dynamodb'

DDB_ClIENT = Aws::DynamoDB::Client.new

def update(event:, context:)
  begin
    puts "Received Request: #{event}"

    data = JSON.parse(event['body'])
    timestamp = Time.now.to_i

    params = {
      key: {
        id: event['pathParameters']['id']
      },
      table_name: ENV['DYNAMODB_TABLE'],
      update_expression: 'set task = :task, checked = :checked, updatedAt = :updatedAt',
      expression_attribute_values: {
        ':task' => data['task'],
        ':checked' => data['checked'],
        ':updatedAt' => timestamp
      },
      return_values: 'UPDATED_NEW'
    }
    # Update DB record
    resp = DDB_ClIENT.update_item(params)

    { statusCode: 200, body: JSON.generate(success: true, todo: resp['attributes']) }
  rescue StandardError => e  
    puts e.message  
    puts e.backtrace.inspect  
    { statusCode: 400, body: JSON.generate("Bad request, Error - #{e.message}") }
  end
end
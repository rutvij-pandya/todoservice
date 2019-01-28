require 'json'
require 'aws-sdk-dynamodb'

DDB_ClIENT = Aws::DynamoDB::Client.new

def delete(event:, context:)
  begin
    puts "Received Request: #{event}"

    params = {
      key: {
        id: event['pathParameters']['id']
      },
      table_name: ENV['DYNAMODB_TABLE']
    }

    resp = DDB_ClIENT.delete_item(params)

    { statusCode: 200, body: JSON.generate("Deleted Todo successfully!") }
  rescue StandardError => e  
    puts e.message  
    puts e.backtrace.inspect  
    { statusCode: 400, body: JSON.generate("Bad request, Error - #{e.message}") }
  end
end
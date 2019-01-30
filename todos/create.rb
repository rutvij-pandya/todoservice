require 'json'
require 'securerandom'
require 'aws-sdk-dynamodb'

DDB_ClIENT = Aws::DynamoDB::Client.new

def create(event:, context:)
  begin
    puts "Received Request: #{event}"
    result = create_todo(event)

    { statusCode: 200, body: JSON.generate(success: true, todo: result) }
  rescue StandardError => e  
    puts e.message  
    puts e.backtrace.inspect  
    { statusCode: 400, body: JSON.generate("Bad request, Error - #{e.message}") }
  end
end

def create_todo(event)
  data = JSON.parse(event['body'])
  timestamp = Time.now.to_i

  params = {
    item: {
      id: SecureRandom.hex(10),
      task: data['task'],
      checked: false,
      createdAt: timestamp,
      updatedAt: timestamp
    },
    table_name: ENV['DYNAMODB_TABLE']
  }
  # Create DB record
  DDB_ClIENT.put_item(params)
  
  {id: params[:item][:id]}
end
require 'json'
require 'securerandom'
require 'aws-sdk-dynamodb'

DDB_ClIENT = Aws::DynamoDB::Client.new

def create(event:, context:)
  begin
    puts "Received Request: #{event}"

    data = JSON.parse(event['body'])
    timestamp = Time.now.to_i

    params = {
      item: {
        id: SecureRandom.hex(10),
        text: data['text'],
        checked: false,
        createdAt: timestamp,
        updatedAt: timestamp
      },
      table_name: ENV['DYNAMODB_TABLE']
    }
    # Create DB record
    resp = DDB_ClIENT.put_item(params)

    { statusCode: 200, body: JSON.generate("Todo has been added successfully! #{params[:item].inspect}") }
  rescue StandardError => e  
    puts e.message  
    puts e.backtrace.inspect  
    { statusCode: 400, body: JSON.generate("Bad request, Error - #{e.message}") }
  end
end
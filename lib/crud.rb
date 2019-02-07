require 'aws-sdk-dynamodb'

DDB_ClIENT = Aws::DynamoDB::Client.new

# Create DB record
def create_record(table, data)
  timestamp = Time.now.to_i
  
  params = {
    item: data.merge(createdAt: timestamp, updatedAt: timestamp),
    table_name: table
  }
    DDB_ClIENT.put_item(params)
  
  data[:id]
end

# Update DB record
def update_record(table, id, data)
  params = {
    key: { id: id },
    table_name: table,
    return_values: 'UPDATED_NEW'
  }
  params.merge!(data)

  DDB_ClIENT.update_item(params)
end

# Find DB record
def find_record(table, id)
  params = {
    key: { id: id },
    table_name: table
  }

  DDB_ClIENT.get_item(params)
end

# Delete DB record
def delete_record(table, id)
  params = {
    key: { id: id },
    table_name: table
  }

  DDB_ClIENT.delete_item(params)
end
VERTEX_CLASSES = [ ExampleVertex ]
EDGE_CLASSES =   [ ExampleEdge ]
OBJECT_CLASSES = VERTEX_CLASSES + EDGE_CLASSES
DATABASE_CLASSES = OBJECT_CLASSES.map(&:collection_name) + %w( people )

# Create database
def create_database
  ArangoDB::OGM.graph_name = 'arangodb_graph_test'
  unless ArangoDB::OGM.client('/_db/_system', '_api/database').get.body['result'].try(:include?, ArangoDB::OGM.client.uri.database)
    ArangoDB::OGM.client('/_db/_system', '_api/database').post('name' => ArangoDB::OGM.client.uri.database)
  end

  ArangoDB::OGM.client.graph.post('name' => ArangoDB::OGM.graph_name, "edgeDefinitions" => [
    {
      "collection" => ExampleEdge.collection_name,
      "from"       => [ ExampleVertex.collection_name ],
      "to"         => [ ExampleVertex.collection_name ]
    }
  ] )
end

# Drop database
def drop_database
  ArangoDB::OGM.client('/_db/_system', '_api/database', ArangoDB::OGM.client.uri.database).delete if ArangoDB::OGM.client('/_db/_system/_api/database').get.body['result'].try(:include?, ArangoDB::OGM.client.uri.database)
end

# Create database classes
def create_database_classes
  endpoint = ArangoDB::OGM.client('_api/collection')
  DATABASE_CLASSES.each do |collection|
    endpoint.post('name' => collection) unless endpoint.get.body['names'].keys.try(:include?, collection)
  end
end

# Drop database classes
def clear_database_classes
  endpoint = ArangoDB::OGM.client('_api/collection')
  DATABASE_CLASSES.each do |collection|
    endpoint.resource(collection, 'truncate').put if endpoint.get.body['names'].keys.try(:include?, collection)
  end
end

RSpec.shared_context "with database", :with_database => true do
  before(:all)  { create_database }
  before(:all)  { create_database_classes }
  before(:each) { clear_database_classes }
  after(:all)   { drop_database }
end

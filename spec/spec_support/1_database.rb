graph_definition = {
  "edgeDefinitions" => [
    {
      "collection" => ExampleEdge.collection_name,
      "from" => [ ExampleVertex.collection_name ],
      "to" => [ ExampleVertex.collection_name ]
    }
  ],
  "orphanCollections" => [ TimestampObject.collection_name ]
}

$strategy = ArangoDB::Test::Strategy.new(client: ArangoDB::Client.new, graph_name: ArangoDB::OGM.graph_name, collections: %w(people), graph_definition: graph_definition)

RSpec.configure do |config|
  config.before(:suite) { $strategy.before_suite }
  config.before(:each)  { $strategy.before_spec }
  config.after(:each)   { $strategy.after_spec }
  config.after(:suite)  { $strategy.after_suite }
end

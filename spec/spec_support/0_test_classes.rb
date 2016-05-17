# Example Vertex
class ExampleVertex
  include ArangoDB::OGM::Vertex
end

# Example Edge
class ExampleEdge
  include ArangoDB::OGM::Edge
end

# Example Timestamp Object
class TimestampObject
  include ArangoDB::OGM::Vertex
  include ArangoDB::OGM::Model::Timestamps
end

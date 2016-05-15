module ArangoDB
  module OGM
    module Vertex
      module Edges
        extend ActiveSupport::Concern

        included do

          def edges(edge_class = nil, direction = 'any', options = {})
            return Queries::Edges.new(graph: ArangoDB::OGM.graph_name, start: self, edges: edge_class, direction: direction).execute
          end

          def inbound_edges(edge_class = nil)
            edges(edge_class, 'inbound')
          end

          alias :in_edges :inbound_edges

          def outbound_edges(edge_class = nil)
            edges(edge_class, 'outbound')
          end

          alias :out_edges :inbound_edges

        end # included

        class_methods do
        end # class_methods

      end
    end
  end
end
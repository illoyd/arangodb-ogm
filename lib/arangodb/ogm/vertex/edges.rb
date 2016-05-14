module ArangoDB
  module OGM
    module Vertex
      module Edges
        extend ActiveSupport::Concern

        included do

          def edges(edge_class = nil)
            neighbours(edge_class, 'any')
          end

          def inbound_edges(edge_class = nil)
            neighbours(edge_class, 'inbound')
          end

          alias :in_edges :inbound_edges

          def outbound_edges(edge_class = nil)
            neighbours(edge_class, 'outbound')
          end

          alias :out_edges :inbound_edges

          def neighbours(edge_class = nil, direction = nil, options = {})
            return Queries::Neighbours.new(ArangoDB::OGM.graph_name, 'start' => self, 'edges' => edge_class, 'direction' => direction).execute
          end

        end # included

        class_methods do
        end # class_methods

      end
    end
  end
end
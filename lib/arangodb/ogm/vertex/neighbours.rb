module ArangoDB
  module OGM
    module Vertex
      module Neighbours
        extend ActiveSupport::Concern

        included do

          def neighbours(edge_class = nil, direction = 'any', options = {})
            return Queries::Neighbours.new(ArangoDB::OGM.graph_name, 'start' => self, 'edges' => edge_class, 'direction' => direction).execute
          end

          def inbound_neighbours(edge_class = nil)
            neighbours(edge_class, 'inbound')
          end

          alias :in_neighbours :inbound_neighbours

          def outbound_neighbours(edge_class = nil)
            neighbours(edge_class, 'outbound')
          end

          alias :out_neighbours :inbound_neighbours

        end # included

        class_methods do
        end # class_methods

      end
    end
  end
end
module ArangoDB
  module OGM
    module Queries

      class Edges < Base

        attr_reader :graph, :start, :direction, :edges

        def initialize(graph: nil, start: nil, edges: [], direction: 'any')
          @graph = graph
          @start = start
          @edges = Array(edges)
          @direction = direction
        end

        def handle
          ArangoDB::OGM::Type.lookup(:document_handle).serialize(@start)
        end

        def direction
          @direction.upcase
        end

        def edges_or_graph_clause
          if @edges.blank?
            "GRAPH '#{ graph }'"
          else
            collection_names_for(@edges).join(', ')
          end
        end

        def to_aql
          "FOR v, e IN #{ direction } '#{ handle }' #{ edges_or_graph_clause } RETURN e"
        end

        def execute
          CollectionResult.new(ArangoDB::OGM.client('_api/cursor').post('query' => self.to_aql).body)
        end

      end

    end
  end
end

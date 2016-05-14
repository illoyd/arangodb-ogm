module ArangoDB
  module OGM
    module Queries

      ##
      # Shorthand for neighbour selection
      class Neighbours < Base

        attr_reader :graph, :start, :options

        def initialize(graph, options = {})
          set_vertex_names(options)
          set_edge_names(options)
          set_direction(options)

          options['includeData'] = true

          @graph = graph
          @start = options.delete('start')
          @start = @start.document_handle if @start.respond_to?(:document_handle)
          @options = options
        end

        def parsed_options
          Oj.dump(options)
        end

        def to_s
          "FOR v IN GRAPH_NEIGHBORS( '#{ graph }', '#{ start }', #{ parsed_options } ) RETURN v"
        end

        def execute
          ArangoDB::OGM.client('_api/cursor').post('query' => self.to_s).result.map { |attr| ArangoDB::OGM.build(attr) }
        end

        protected

        def set_vertex_names(options)
          names = options.delete('vertices')
          if names.present?
            options['vertexCollectionRestriction'] ||= collection_names_for(names)
          end
          options
        end

        def set_edge_names(options)
          names = options.delete('edges')
          if names.present?
            options['edgeCollectionRestriction'] ||= collection_names_for(names)
          end
          options
        end

        def set_direction(options)
          direction = options.delete('direction')
          if direction.present?
            options['direction'] ||= direction if %w( inbound outbound any ).include?(direction)
          end
          options
        end

      end

    end
  end
end
module ArangoDB
  module OGM

    ##
    # Collection result, wrapping the output of a collection-based query in a smart way.
    # Converts the results of a query into documents/vertices/edges as appropriate.
    class CollectionResult < ArangoDB::API::CollectionResult

      def initialize(result_document, client: nil, key: 'result')
        super(result_document, client: ArangoDB::OGM.client, key: key)
        @cached_results = []
      end

      def [](index)
        @cached_results[index] ||= coerce(super)
      end

      protected

      def coerce(document)
        ArangoDB::OGM::Model.build(document) unless document.nil?
      end

    end

  end # OGM
end # ArangoDB
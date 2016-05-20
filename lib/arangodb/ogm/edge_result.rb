module ArangoDB
  module OGM

    class EdgeResult < DocumentResult
      def initialize(result_document, key: 'edge'.freeze)
        super
      end

      alias :edge :document
    end

  end # OGM
end # ArangoDB
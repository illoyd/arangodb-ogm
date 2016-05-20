module ArangoDB
  module OGM

    class VertexResult < DocumentResult
      def initialize(result_document, key: 'vertex'.freeze)
        super
      end

      alias :vertex :document
    end

  end # OGM
end # ArangoDB
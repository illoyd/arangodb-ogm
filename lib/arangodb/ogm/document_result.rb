module ArangoDB
  module OGM

    ##
    # A simple wrapper for results to return a document object.
    class DocumentResult

      def initialize(result_document, key: nil)
        @original_document = result_document
        @key = key.to_s
      end

      def document
        @cached_document ||= coerce
      end

      protected

      def original_document_contents
        @key.present? ? @original_document[@key] : @original_document
      end

      def coerce
        ArangoDB::OGM::Model.build(original_document_contents)
      end

    end

  end # OGM
end # ArangoDB
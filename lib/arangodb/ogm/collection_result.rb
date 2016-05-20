module ArangoDB
  module OGM

    ##
    # Collection result, wrapping the output of a collection-based query in a smart way.
    # Converts the results of a query into documents/vertices/edges as appropriate.
    class CollectionResult
      include Enumerable

      def initialize(result_document, key: 'result')
        @current_result_document = result_document
        @original_results = @current_result_document[key]
        @cached_results = []
      end

      def empty?
        load_next_batch while @original_results.empty? && more?
        @original_results.empty?
      end

      def load_all
        load_next_batch while more?
      end

      def count_all
        load_all
        @original_results.count
      end

      def count
        @current_result_document['count'] || count_all
      end

      def [](index)
        load_next_batch while @original_results[index].nil? && more?
        @cached_results[index] ||= coerce(@original_results[index])
      end

      def cursor
        ArangoDB::OGM.client.cursor(cursor_id)
      end

      def more?
        @current_result_document['hasMore'.freeze]
      end

      def cursor_id
        @current_result_document['id'.freeze]
      end

      def load_next_batch
        @current_result_document = cursor.get.body
        @original_results.concat(@current_result_document[key])
      end

      def each
        enum_for(:each) unless block_given?

        index = 0
        until self[index].nil?
          yield self[index]
          index += 1
        end
      end

      protected

      def coerce(document)
        ArangoDB::OGM::Model.build(document) unless document.nil?
      end

    end

  end # OGM
end # ArangoDB
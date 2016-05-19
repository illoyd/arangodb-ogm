module ArangoDB
  module OGM
  
    ##
    # A simple wrapper for results to return a document object.
    class DocumentResult
    
      def initialize(result_document, key: nil)
        @result_document = result_document
      end
      
      def document
        @document ||= ArangoDB::OGM::Model.build(document_contents)
      end

      def document_contents
        key.present? ? @result_document[key] : @result_document
      end
      
    end
    
    class VertexResult < DocumentResult
      def initialize(result_document, key: 'vertex')
        super
      end
      
      alias :vertex :document
    end
      
    class EdgeResult < DocumentResult
      def initialize(result_document, key: 'edge')
        super
      end
      
      alias :edge :document
    end
      

    ##
    # Collection result, wrapping the output of a collection-based query in a smart way.
    # Converts the results of a query into documents/vertices/edges as appropriate.
    class CollectionResult
        include Enumerable

        def initialize(result_document, key: 'result')
            @current_result_document = result_document
            @raw_results = @current_result_document[key]
        end
        
        def [](index)
            load_next_batch while @raw_results[index].nil? && more?
            @cached_results[index] ||= ArangoDB::OGM::Model.build(@raw_results[index])
        end
        
        def cursor
            ArangoDB::OGM.client.cursor(cursor_id)
        end
        
        def more?
            @current_result_document['hasMore'.freeze] || false
        end
        
        def cursor_id
            @current_result_document['id'.freeze]
        end
        
        def load_next_batch
            @current_result_document = cursor.get.body
            @raw_results.concat(@current_result_document[key])
        end
        
        def each
            enum_for(:each) unless block_given?

            index = 0
            until self[index].nil?
                yield self[index]
                index += 1
            end
        end
    end

  and # OGM
end # ArangoDB
module ArangoDB
  module OGM
    module Finders
      extend ActiveSupport::Concern

      included do
      end

      class_methods do

        def count
          ArangoDB::OGM.client('_api/collection', collection_name, 'count').get.body['count']

          rescue ArangoDB::API::ResourceNotFound => e
            return 0
        end

        def all
          ArangoDB::OGM.client('_api/simple/all').put(collection: collection_name).body['result'].map { |obj| new(obj) }
        end

        def where(search={})
          ArangoDB::OGM.client('_api/simple/by-example').put(collection: collection_name, example: search).body['result'].map { |obj| new(obj) }
        end

        def find_by(search={})
          find_by!(search)

          rescue ArangoDB::OGM::ObjectNotFound, ArangoDB::API::ResourceNotFound
            return nil
        end

        def find_by!(search={})
          new( ArangoDB::OGM.client('_api/simple/first-example').put(collection: collection_name, example: search).body['document'] )
        end

        def find(id)
          find!(id)

          rescue ArangoDB::OGM::ObjectNotFound, ArangoDB::API::ResourceNotFound
            return nil
        end

        def find!(id)
          new( ArangoDB::OGM.client('_api/document', collection_name, id).get.body )
        end

        def first
          new( ArangoDB::OGM.client('_api/simple/first').put(collection: collection_name).body['result'] )
        end

        def last
          new( ArangoDB::OGM.client('_api/simple/last').put(collection: collection_name).body['result'] )
        end

        ##
        # Find or create a new object by the given attributes.
        # Will perform a find_by and, if not found, create using the given properties.
        def find_or_create_by(attributes)
          find_by(attributes) || create(attributes)
        end

        def find_or_create_by!(attributes)
          find_by(attributes) || create!(attributes)
        end

        ##
        # Find or initialize a new object by the given attributes.
        # Effectively, performs a find_by and, if not found, a new with the given properties.
        def find_or_initialize_by(attributes)
          find_by(attributes) || new(attributes)
        end

      end

    end
  end
end
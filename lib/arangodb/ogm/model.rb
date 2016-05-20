%w( schema_aware attribute_assignment attributes finders persistence timestamps ).each { |file| require "arangodb/ogm/model/#{ file }" }

module ArangoDB
  module OGM

    ##
    # The Model, a baseline mixin for objects to interact with the ArangoDB Document system.
    # It is prefereable to use the Vertex or Edge mixins as those provide specific support for each
    # of those types in the Graph database.
    module Model
      extend ActiveSupport::Concern
      extend ActiveModel::Callbacks

      include ActiveModel::Model
      include ActiveModel::AttributeMethods
      include ActiveModel::Dirty

      include ArangoDB::OGM::Model::SchemaAware
      include ArangoDB::OGM::Model::AttributeAssignment
      include ArangoDB::OGM::Model::Attributes
      include ArangoDB::OGM::Model::Finders
      include ArangoDB::OGM::Model::Persistence

      include AttributeNormalizer

      def self.build(document)

        case document

        when ->(doc){ doc.try(:has_key?, '_id'.freeze) }
          return build_from_document(document)

        when Enumerable
          document.map { |subdoc| build(subdoc) }

        else
          document
        end

      end

      def self.build_from_document(document)
        handle = document['_id'.freeze]
        handle = ArangoDB::DocumentHandle.new(handle) unless handle.is_a?(ArangoDB::DocumentHandle)

        handle.model_class.new(document).tap do |model|
          model.document_attributes.each do |k,v|
            model[k] = build(v) if v.is_a?(Enumerable)
          end
        end
      end

      included do

        attribute_method_suffix '?'
        attribute_method_suffix '='

        delegate :to_param, to: :id, allow_nil: true

        def initialize(new_attributes={})
          # Setup basic attributes
          @attributes         = HashWithIndifferentAccess.new

          # Add any default attributes from schema
          assign_attributes(schema.default_attributes)

          # Allow super to execute
          super

          # Ignore all changes
          changes_applied
        end

        def persisted?
          self.document_handle.present?
        end

        ##
        # Map id to _key
        def id
          attribute('_key'.freeze)
        end

        ##
        # Map document_handler to _id
        def document_handle
          attribute('_id'.freeze)
        end

        def collection_name
          self.class.collection_name
        end

      end # included

      class_methods do

        def collection_name
          self.name.tableize
        end

      end # class_methods

    end
  end
end
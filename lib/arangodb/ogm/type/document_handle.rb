require 'active_model/type'

module ArangoDB
  module OGM
    module Type

      class DocumentHandle < ActiveModel::Type::Value

        def serialize(value)
          return serialize(value.document_handle) if value.respond_to?(:document_handle)
          value.to_s
        end

        private

        def cast_value(value)
          # If value is already a DocumentHandle, return it
          return value if value.is_a?(ArangoDB::DocumentHandle)

          # If value has a DocumentHandle, return it
          return value.document_handle if value.respond_to?(:document_handle)

          # Otherwise, try to convert it to a DH
          ArangoDB::DocumentHandle.new(value)
        end

      end # DocumentHandle

    end # Type
  end # OGM
end # ArangoDB
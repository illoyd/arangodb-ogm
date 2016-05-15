require 'arangodb/ogm/edge/persistence'

module ArangoDB
  module OGM
    module Edge
      extend ActiveSupport::Concern
      include ArangoDB::OGM::Document
      include ArangoDB::OGM::Edge::Persistence

      included do
        attribute :_from, :document_handle, validations: { presence: true }
        attribute :_to,   :document_handle, validations: { presence: true }

        def from
          @cached_from ||= self._from.try(:fetch)
        end

        def from=(value)
          @cached_from = value.respond_to?(:document_handle) ? value : nil
          self._from = value
        end

        def to
          @cached_to ||= self._to.try(:fetch)
        end

        def to=(value)
          @cached_to = value.respond_to?(:document_handle) ? value : nil
          self._to = value
        end

      end # included

      class_methods do
      end # class_methods

    end
  end
end
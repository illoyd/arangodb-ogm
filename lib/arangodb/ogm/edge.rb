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
          if self.attribute('_from').is_a?(ArangoDB::DocumentHandle)
            self.from = self.attribute('_from').fetch
          end
          self.attribute('_from')
        end

        def from=(value)
          self.send(:attribute=, '_from', value)
        end

        def to
          if self.attribute('_to').is_a?(ArangoDB::DocumentHandle)
            self.from = self.attribute('_to').fetch
          end
          self.attribute('_to')
        end

        def to=(value)
          self.send(:attribute=, '_to', value)
        end

      end # included

      class_methods do
      end # class_methods

    end
  end
end
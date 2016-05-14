module ArangoDB
  module OGM
    module AttributeAssignment
      extend ActiveSupport::Concern

      included do

        private

        ##
        # Dynamically insert the attribute key into the attribute hash to
        # implement the rest of the toolkit.
        def _assign_attribute(k, v)
          @attributes[k] ||= nil
          super
        end

      end # included

      class_methods do
      end # class_methods

    end
  end
end
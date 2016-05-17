module ArangoDB
  module OGM
    module Model
      module AttributeAssignment
        extend ActiveSupport::Concern

        included do

          private

          ##
          # Dynamically insert the attribute key into the attribute hash to
          # implement the rest of the toolkit. Checks if the model can already respond
          # to the key assignment so that we do not inadvertently shadow an existing method.
          def _assign_attribute(k, v)
            @attributes[k] ||= nil unless respond_to?("#{k}=")
            super
          end

        end # included

        class_methods do
        end # class_methods

      end
    end
  end
end
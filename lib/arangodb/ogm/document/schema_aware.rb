module ArangoDB
  module OGM
    module SchemaAware
      extend ActiveSupport::Concern

      included do

        def schema
          @schema ||= self.class.compiled_schema.dup
        end

        private

        ##
        # Type cast the given value by the given attribute name
        def _type_cast_value(name, value)
          schema.type_for(name).cast(value)
        end

        ##
        # Serialize value
        def _serialize_value(name, value)
          schema.type_for(name).serialize(value)
        end

      end # included

      class_methods do

        def attribute(name, type, options = {})
          attr = Schema::Attribute.new(name, type, options)

          # Save attribute into schema
          self.schema << attr

          # Configure validations
          if attr.validates_options.try(:any?)
            validates(attr.accessor, attr.validates_options)
          end
        end

        def schema
          @@schemas       ||= {}
          @@schemas[self] ||= ArangoDB::OGM::Schema.new
        end

        def compiled_schema
          schema.tap do |ss|
            ancestors.each do |klass|
              ss.reverse_merge!(@@schemas[klass]) if @@schemas[klass]
            end
          end
        end

      end # class_methods

    end
  end
end
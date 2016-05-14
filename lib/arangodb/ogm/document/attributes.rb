module ArangoDB
  module OGM
    module Attributes
      extend ActiveSupport::Concern

      included do

        attr_reader :attributes

        ##
        # Return the value
        def attribute(name)
          @attributes[name]
        end

        alias :[] :attribute

        ##
        # Assign the attribute with the given value.
        def attribute=(name, value)
          value = _normalize_attribute(name, value)
          if _value_changed?(name, @attributes[name], value)
            attribute_will_change!(name)
            @attributes[name] = _type_cast_value(name, value)
          end
        end

        alias :[]= :attribute=

        ##
        # Determines if the attribute is present in the current object.
        def attribute?(attr)
          attribute(attr).present?
        end

        alias :include? :attribute?

        ##
        # Return all non-system attributes (e.g. anything without a prefixed underscore)
        def document_attributes
          attributes.select { |k,_| k.to_s[0] != '_'.freeze }
        end

        ##
        # Return all non-system attributes (e.g. anything without a prefixed underscore)
        def system_attributes
          attributes.select { |k,_| k.to_s[0] == '_'.freeze }
        end

        private

        ##
        # Check if value is changing
        def _value_changed?(name, old_value, new_value)
          type = schema.type_for(name)
          cast_value = type.cast(new_value)
          type.changed?(old_value, cast_value, new_value) || type.changed_in_place?(old_value, new_value)
        end

        ##
        # Normalize by stripping and blanking, as appropriate
        def _normalize_attribute(name, value)
          normalized = value

          schema[name].normalizers.each do |normalizer|
            normalized = normalizer.respond_to?(:normalize) ? normalizer.normalize(normalized) : normalizer.call(normalized)
          end

          normalized
        end

      end # included

      class_methods do
      end # class_methods

    end
  end
end
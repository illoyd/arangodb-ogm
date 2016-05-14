require 'arangodb/ogm/schema/attribute'

module ArangoDB
  module OGM
    class Schema

      attr_reader :attributes

      delegate :keys, to: :attributes

      def initialize()
        @attributes = {}

        self << Attribute.new('_id', :document_handle)

        # Set a default attribute definition if one is not already set
        if @attributes.default.nil?
          @attributes.default = Attribute.new(nil, :value)
        end
      end

      def dup
        self.class.new.tap do |schema|
          schema.reverse_merge!(self)
        end
      end

      def <<(attr)
        @attributes[attr.name] = attr
      end

      def [](name)
        @attributes[name.to_s]
      end

      def serialize(name, value)
        self[name].type.serialize(value)
      end

      def deserialize(name, value)
        self[name].type.deserialize(value)
      end

      def cast(name, value)
        self[name].type.cast(value)
      end

      def type_for(name)
        self[name].type
      end

      def default_for(name)
        self[name].default
      end

      def default_attributes
        @attributes.values.each_with_object({}) do |v,h|
          h[v.name] = v.default
        end
      end

      def merge!(other)
        @attributes.merge!(other.attributes)
      end

      def reverse_merge!(other)
        @attributes.reverse_merge!(other.attributes)
      end

      def serialize_attributes(values)
        values.each_with_object({}) do |(k,v),h|
          h[k.to_s] = serialize(k.to_s,v)
        end
      end

    end
  end
end
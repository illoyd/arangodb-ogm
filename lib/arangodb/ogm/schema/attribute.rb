module ArangoDB
  module OGM
    class Schema

      ##
      # TODO: Convert to a struct
      class Attribute
        attr_accessor :name, :accessor, :type, :validates_options

        def initialize(name, type = :value, options = {})
          @name              = name.to_s
          @accessor          = options[:accessor] || name
          @type              = self.class.coerce_type(type)
          @default           = options[:default] || ( @type.method(:default) if @type.respond_to?(:default) )
          @validates_options = options[:validates]
          @normalizers       = _normalizers_or_default(options[:normalizes] || options[:normalizers])
        end

        def normalizers
          @cached_normalizers ||= @normalizers.map { |normalizer| normalizer.is_a?(Symbol) ? AttributeNormalizer.configuration.normalizers[normalizer] : normalizer }
        end

        def default
          @default.respond_to?(:call) ? @default.call : @default
        end

        def self.coerce_type(type)
          case type
          when ActiveModel::Type::Value
            type
          else
            ArangoDB::OGM::Type.lookup(type)
          end
        end

        private

        def _normalizers_or_default(options = nil)
          if options == :default
            [ :strip, :blank ]
          else
            Array(options)
          end
        end
    end

    end # Schema
  end # OGM
end # ArangoDB

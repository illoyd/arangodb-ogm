require "arangodb/ogm/version"

# Require supporting libraries
require 'logger'
require 'active_model'
require 'active_support/core_ext'
require 'attribute_normalizer'
require 'arangodb/api'

# Include needed files
%w( type schema model document vertex edge ).each { |file| require "arangodb/ogm/#{ file }" }

# Include queries
%w( base neighbours edges ).each { |file| require "arangodb/ogm/queries/#{ file }" }

module ArangoDB

  class DocumentHandle
    def fetch
      self.model_class.find(self.key)
    end
  end

  module OGM
    class Error < StandardError
      attr_reader :original
      def initialize(msg, orig = $!)
        super(msg)
        @original = orig
      end
    end

    class ObjectNotFound < Error; end

    class ObjectError < Error
      attr_reader :object
      def initialize(msg, obj, orig = $!)
        super(msg, orig)
        @object = obj
      end
    end

    class ObjectNotSaved < ObjectError; end

    ##
    # Client instance.
    def self.client(*paths)
      if paths.empty?
        @@client ||= ArangoDB::Client.new
      else
        self.client.resource(*paths)
      end
    end

    ##
    # Graph!
    def self.graph_name
      @@graph_name ||= self.default_graph_name
    end

    def self.graph_name=(value)
      @@graph_name = value
    end

    def self.default_graph_name
      ENV['ARANGODB_GRAPH']
    end

    def self.graph(graph_name = nil)
      self.client.graph(graph_name || self.graph_name)
    end

    def self.build(attributes)
      handle = attributes['_id']
      handle = ArangoDB::DocumentHandle.new(handle) unless handle.is_a?(ArangoDB::DocumentHandle)
      handle.collection.classify.constantize.new(attributes)
    end
  end
end

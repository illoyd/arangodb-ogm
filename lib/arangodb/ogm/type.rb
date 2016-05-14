module ArangoDB
  module OGM

    ##
    # Type module for type casting and serialising data between ORM objects, the database, and users.
    # This module includes a cache for ActiveModel::Type.lookup, so that we are not spewing dozens
    # of small type casting objects all over the place.
    #
    # Types should still be registered with the main ActiveModel::Type however.
    module Type

      def self.lookup(symbol, *args)
        @@cache ||= HashWithIndifferentAccess.new
        @@cache[symbol] ||= ActiveModel::Type.lookup(symbol, *args)
      end

    end # Type

  end # OGM
end # ArangoDB

require 'arangodb/ogm/type/document_handle'

ActiveModel::Type.register :value, ActiveModel::Type::Value
ActiveModel::Type.register :document_handle, ArangoDB::OGM::Type::DocumentHandle

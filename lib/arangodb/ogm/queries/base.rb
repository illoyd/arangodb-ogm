module ArangoDB
  module OGM
    module Queries

      ##
      # Collection of helper methods for working with queries.
      class Base

        def inspect
          "<#{ self.class } #{ self }>"
        end

        protected

        def collection_names_for(*names)
          names.flatten.map { |name| name.try(:collection_name) || name }
        end

      end

    end
  end
end
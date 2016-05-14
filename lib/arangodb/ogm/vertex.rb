%w( persistence neighbours ).each { |file| require "arangodb/ogm/vertex/#{ file }" }

module ArangoDB
  module OGM
    module Vertex
      extend ActiveSupport::Concern
      include ArangoDB::OGM::Document
      include ArangoDB::OGM::Vertex::Persistence
      include ArangoDB::OGM::Vertex::Neighbours

      included do
      end # included

      class_methods do
      end # class_methods

    end
  end
end
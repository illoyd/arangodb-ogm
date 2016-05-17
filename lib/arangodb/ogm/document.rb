%w( persistence ).each { |file| require "arangodb/ogm/document/#{ file }" }

module ArangoDB
  module OGM
    module Document
      extend ActiveSupport::Concern
      include ArangoDB::OGM::Model
      include ArangoDB::OGM::Document::Persistence

      included do
      end # included

      class_methods do
      end # class_methods

    end
  end
end
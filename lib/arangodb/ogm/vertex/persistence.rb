module ArangoDB
  module OGM
    module Vertex
      module Persistence
        extend ActiveSupport::Concern

        included do

          def destroy
            run_callbacks :destroy do
              ArangoDB::OGM.graph.resource('vertex', document_handle).delete
            end
          end

          protected

          def _create
            run_callbacks :create do
              results = ArangoDB::OGM.graph.resource('vertex', collection_name).post(attributes)

              assign_attributes(results.body['vertex'])
              changes_applied
              persisted?
            end
          end

          def _update
            run_callbacks :update do
              results = ArangoDB::OGM.graph.resource('vertex', document_handle).patch(attributes)

              assign_attributes(results.body['vertex'])
              changes_applied
              persisted?
            end
          end

        end # included

        class_methods do
        end # class_methods

      end
    end
  end
end
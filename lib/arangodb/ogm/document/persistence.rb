module ArangoDB
  module OGM
    module Document
      module Persistence
        extend ActiveSupport::Concern

        included do

          def destroy
            run_callbacks :destroy do
              ArangoDB::OGM.client('_api/document', document_handle).delete
            end
          end

          protected

          def _create
            run_callbacks :create do
              results = ArangoDB::OGM.client('_api/document').post(attributes) do |request|
                request.params['collection'] = collection_name
                request.params['createCollection'] = true
              end

              assign_attributes(results.body)
              changes_applied
              persisted?
            end
          end

          def _update
            run_callbacks :update do
              results = ArangoDB::OGM.client('_api/document', document_handle).patch(attributes)

              assign_attributes(results.body)
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
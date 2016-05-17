module ArangoDB
  module OGM
    module Model
      module Persistence
        extend ActiveSupport::Concern

        included do

          define_model_callbacks :validation, :save, :create, :update, :destroy

          def save
            return false unless valid?
            run_callbacks :save do
              create_or_update
            end
          end

          def save!
            save || ( raise ArangoDB::OGM::ObjectNotSaved.new(self.errors.messages, self) )
          end

          def update(new_attributes)
            assign_attributes(new_attributes)
            save
          end

          def update!(new_attributes)
            assign_attributes(new_attributes)
            save!
          end

          def reload!
            obj = self.class.find(self.id)
            assign_attributes(obj.attributes)
            changes_applied
            self
          end

          def valid?
            run_callbacks :validation do
              super
            end
          end

          protected

          def create_or_update
            persisted? ? _update : _create
          end

        end # included

        class_methods do

          def create(attributes={})
            new(attributes).tap { |object| object.save }
          end

          def create!(attributes={})
            new(attributes).tap { |object| object.save! }
          end

        end # class_methods

      end
    end
  end
end
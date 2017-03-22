# Generated via
#  `rails generate hyrax:work Thesis`
module Hyrax
  module Actors
    class ThesisActor < Hyrax::Actors::BaseActor
      include CreatorsHelper
      include LocalActorsHelper

      def create(attributes)
        @cloud_resources = attributes.delete(:cloud_resources.to_s)
        apply_creators(attributes)
        apply_dates(attributes)
        apply_creation_data_to_curation_concern
        apply_save_data_to_curation_concern(attributes)
        save &&
            next_actor.create(attributes) &&
            run_callbacks(:after_create_concern)
      end

      def update(attributes)
        apply_creators(attributes)
        apply_dates(attributes)
        apply_update_data_to_curation_concern
        apply_save_data_to_curation_concern(attributes)
        save &&
            next_actor.update(attributes) &&
            run_callbacks(:after_update_metadata)
      end

      protected

      # add a combined dates field to use in facets
      def apply_dates(attributes)
        attributes[:date] ||= []
        attributes[:date] << attributes[:date_of_award]
        attributes[:date].uniq!
      end

      # TODO - Advisor (similar to Creator)
      # TODO = Awarding Institution

    end
  end
end

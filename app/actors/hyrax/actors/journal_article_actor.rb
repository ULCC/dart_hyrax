# Generated
#  `rails generate local:work JournalArticle`
module Hyrax
  module Actors
    # JournalArticleActor
    class JournalArticleActor < Hyrax::Actors::BaseActor
      include PeopleHelper,
              LocalActorsHelper,
              ProjectsHelper,
              ManagingOrganisationHelper

      def create(attributes)
        @cloud_resources = attributes.delete(:cloud_resources.to_s)
        apply_creators(attributes)
        apply_projects(attributes)
        apply_managing_organisation(attributes)
        apply_dates(attributes)
        apply_creation_data_to_curation_concern
        apply_save_data_to_curation_concern(attributes)
        save &&
          next_actor.create(attributes) &&
          run_callbacks(:after_create_concern)
      end

      def update(attributes)
        apply_creators(attributes)
        apply_projects(attributes)
        apply_dates(attributes)
        apply_managing_organisation(attributes)
        apply_update_data_to_curation_concern
        apply_save_data_to_curation_concern(attributes)
        save &&
          next_actor.update(attributes) &&
          run_callbacks(:after_update_metadata)
      end

      protected

      def apply_managing_organisation(attributes)
        attributes[:managing_organisation_resource_ids] = [managing_organisation_id]
        attributes
      end

      # Find the object for each project_resource_id
      # Create new Project object from project_name
      #   and project_identifier
      # This is a drop-down, so the object id is returned
      def apply_projects(attributes)
        attributes[:project_resource] ||= []
        attributes[:project_resource_ids].collect do |project|
          attributes[:project_resource] << find_base(project)
        end
        unless attributes[:project_name].blank?
          attributes[:project_resource] <<
            create_project(attributes[:project_name],
                           attributes[:project_identifier])
        end
        trim_attributes(attributes, [:project_identifier,
                                     :project_name, :project_resource_ids])
      end

      # add a combined dates field to use in facets
      def apply_dates(attributes)
        attributes[:date] ||= []
        attributes[:date] << attributes[:date_published]
        attributes[:date] << attributes[:date_available]
        attributes[:date] << attributes[:date_accepted]
        attributes[:date] << attributes[:date_submitted]
        attributes[:date].uniq!
      end

    end
  end
end

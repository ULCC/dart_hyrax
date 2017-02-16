# Generated
#  `rails generate local:work JournalArticle`
module Hyrax
  module Actors
    # JournalArticleActor
    class JournalArticleActor < Hyrax::Actors::BaseActor
      include CreatorsHelper
      include LocalActorsHelper
      include ProjectsHelper

      def create(attributes)
        @cloud_resources = attributes.delete(:cloud_resources.to_s)
        apply_creators(attributes)
        apply_projects(attributes)
        apply_creation_data_to_curation_concern
        apply_save_data_to_curation_concern(attributes)
        save &&
          next_actor.create(attributes) &&
          run_callbacks(:after_create_concern)
      end

      def update(attributes)
        apply_creators(attributes)
        apply_projects(attributes)
        apply_update_data_to_curation_concern
        apply_save_data_to_curation_concern(attributes)
        save &&
          next_actor.update(attributes) &&
          run_callbacks(:after_update_metadata)
      end

      protected

      # Find the object for each creator_reource_id
      # Create new object from project_name and project_identifier
      # For ORCIDs, validate and lookup the ORCID
      #   create CurrentPerson from the ORCID
      # This is an autosuggest, so the value is returned
      def apply_creators(attributes)
        attributes[:creator_resource] ||= []
        attributes[:creator_resource_ids].collect do |creator|
          attributes[:creator_resource] << add_person(creator)
        end
        # attributes[:orcid].collect do |orcid|
        #   attributes[:creator_resource] << create_person(orcid)
        # end
        # trim_attributes(attributes, [:creator_resource_ids, :orcid])
        trim_attributes(attributes, [:creator_resource_ids])
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
    end
  end
end

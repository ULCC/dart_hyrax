# Generated via
#  `rails generate local:work JournalArticle`
module Hyrax
  module Actors
    class JournalArticleActor < Hyrax::Actors::BaseActor

      def create(attributes)
        @cloud_resources = attributes.delete(:cloud_resources.to_s)
        apply_creators(attributes)
        apply_projects(attributes)
        apply_creation_data_to_curation_concern
        apply_save_data_to_curation_concern(attributes)
        save && next_actor.create(attributes) && run_callbacks(:after_create_concern)
      end

      def update(attributes)
        apply_creators(attributes)
        apply_projects(attributes)
        apply_update_data_to_curation_concern
        apply_save_data_to_curation_concern(attributes)
        save && next_actor.update(attributes) && run_callbacks(:after_update_metadata)
      end

      protected

      # Check each creator_reource_id; create a CurrentPerson for any strings.
      # Check creator_string; create CurrentPerson for each.
      # Lookup ORCID; create CurrentPerson from ORCID.
      def apply_creators(attributes)
        values = []
        cp_service = AuthorityService::CurrentPersonService.new
        attributes[:creator_resource_ids].each do |creator|
          existing_person = cp_service.find_id(creator)
          if existing_person.blank?
            values << create_person(creator)
          else
            begin
              values << ActiveFedora::Base.find(existing_person)
            rescue
              # TODO
              values << create_person(creator)
            end
          end
        end

        # TODO Lookup ORCID; create CurrentPerson from ORCID.
        attributes[:orcid].each { |person| values << create_person(person, true) }
        attributes.delete :orcid
        attributes.delete :creator_resource_ids
        attributes[:creator_resource] = values
      end

      def apply_projects(attributes)
        values = []
        attributes[:project_resource_ids].each do |project|
          begin
            values << ActiveFedora::Base.find(project)
          rescue
            # TODO something
          end
        end
        unless attributes[:project_name].blank?
          values << create_project(attributes[:project_name], attributes[:project_identifier])
        end
        attributes.delete :project_identifier
        attributes.delete :project_name
        attributes.delete :project_resource_ids
        attributes[:project_resource] = values
      end

      # Create a CurrentPerson object
      # return CurrentPerson
      # TODO change the orcid part
      def create_person(preflabel, orcid=false)
        person = Dlibhydra::CurrentPerson.new
        person.preflabel = preflabel
        person.orcid = [preflabel] if orcid
        begin
          person.concept_scheme = Dlibhydra::ConceptScheme.find(DLIBHYDRA['current_persons'])
        rescue
          # TODO deal with this situation
        end
        person
      end

      def create_project(name,identifier=nil)
        project = Dlibhydra::Project.new
        project.preflabel = name
        project.name = name
        project.identifier = [identifier] unless identifier.nil?
        begin
          project.concept_scheme = Dlibhydra::ConceptScheme.find(DLIBHYDRA['projects'])
        rescue
          # TODO deal with this situation
        end
        project
      end

    end
  end
end

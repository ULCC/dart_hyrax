# Generated
#  `rails generate local:work JournalArticle`
module Hyrax
  module Actors
    # JournalArticleActor
    class JournalArticleActor < Hyrax::Actors::BaseActor
      include OrcidHelper

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
      #   create CurrentPerson from the ORCID.
      def apply_creators(attributes)
        attributes[:creator_resource] ||= []
        attributes[:creator_resource_ids].collect do |creator|
          attributes[:creator_resource] << find_or_create_person(creator)
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

      # Create a CurrentPerson object from the supplied string / orcid
      # If a CurrentPerson for the orcid exists, update it
      def create_person(value)
        person = Dlibhydra::CurrentPerson.new
        trimmed_value = trim_orcid_url(value)
        if valid_orcid?(trimmed_value)
          np = new_person(trimmed_value)
          person = np unless np.nil?
          person.orcid = [trimmed_value]
          bio = orcid_response(trimmed_value)
          person = create_person_from_orcid(bio, person) unless bio.blank?
        else
          person.preflabel = value
        end
        person.concept_scheme = find_concept_scheme('current_persons')
        return person unless person.preflabel.blank?
      end

      # Create a Project object
      def create_project(name, identifier = nil)
        project = Dlibhydra::Project.new
        project.preflabel = name
        project.name = name
        project.identifier = [identifier] unless identifier.nil?
        project.concept_scheme = find_concept_scheme('projects')
        project
      end

      # Add data from ORCID to CurrentPerson object
      def create_person_from_orcid(orcid_bio, person)
        pd = orcid_bio['orcid-bio']['personal-details']
        person.given_name = pd['given-names']['value']
        person.family_name = pd['family-name']['value']
        person.preflabel =
          "#{person.given_name}, #{person.family_name}"
        unless pd['other-names'].nil?
          person.altlabel =
            pd['other-names']['other-name'].collect { |o| o['value'] }
        end
        person
      end

      # Find the concept_scheme for the supplied scheme name
      def find_concept_scheme(scheme)
        Dlibhydra::ConceptScheme.find(DLIBHYDRA[scheme])
      rescue
        Rails.logger.error("Could not find the concept scheme for #{scheme}.")
      end

      # Find the CurrentPerson in Fedora
      #  if it doesn't exist create a new CurrentPerson
      def find_or_create_person(creator)
        # is it a valid orcid?

        existing_person =
          AuthorityService::CurrentPersonService.new.find_id(creator)
        if existing_person.blank?
          create_person(creator)
        else
          find_base(existing_person)
        end
      end

      def find_base(thing)
        ActiveFedora::Base.find(thing)
      rescue
        Rails.logger.error(
          "Could not find #{thing}."
        )
      end

      # If there is already a CurrentPerson for the given orcid, return it
      def new_person(person_orcid)
        # TODO: don't do the solr query like this, look for helper code
        solr = RSolr.connect url: ENV['SOLR_URL_DEVELOPMENT']
        response = solr.get 'select', params: {
          q: 'inScheme_ssim:"' + DLIBHYDRA['current_persons'] + '"',
          fq: 'orcid_tesim:"' + person_orcid + '"',
          fl: 'id'
        }
        numfound = response['response']['numFound']
        find_base(response['response']['docs'][0]['id']) unless numfound == 0
      end

      # Delete the specified attributes
      def trim_attributes(attributes, to_remove)
        to_remove.each { |a| attributes.delete(a) }
        attributes
      end
    end
  end
end

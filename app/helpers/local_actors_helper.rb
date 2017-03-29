# Local Actors Helper
module LocalActorsHelper
  include PeopleHelper
  include OrganisationsHelper

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
    trim_attributes(attributes, [:creator_resource_ids])
  end

  def apply_advisors(attributes)
    attributes[:advisor_resource] ||= []
    attributes[:advisor_resource_ids].collect do |advisor|
      attributes[:advisor_resource] << add_person(advisor)
    end
    trim_attributes(attributes, [:advisor_resource_ids])
  end

  def apply_awarding_institution(attributes)
    attributes[:awarding_institution_resource] ||= []
    attributes[:awarding_institution_resource_ids].collect do |awarding_institution|
      attributes[:awarding_institution_resource] << add_organisation(awarding_institution)
    end
    trim_attributes(attributes, [:awarding_institution_resource_ids])
  end

  # Delete the specified attributes
  def trim_attributes(attributes, to_remove)
    to_remove.each { |a| attributes.delete(a) }
    attributes
  end

  # Find the concept_scheme for the supplied scheme name
  def find_concept_scheme(scheme)
    DogBiscuits::ConceptScheme.find(DLIBHYDRA[scheme])
  rescue
    Rails.logger.error("Could not find the concept scheme for #{scheme}.")
    return nil
  end

  def find_base(thing)
    ActiveFedora::Base.find(thing)
  rescue
    Rails.logger.error(
        "Could not find #{thing}."
    )
  end
end

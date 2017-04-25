# organisations Helper
module OrganisationsHelper

  # Find the Organisation in Fedora
  #  if it doesn't exist create a new Organisation
  def add_organisation(organisation)
    find_or_create_organisation(organisation)
  end

  def find_or_create_organisation(organisation)
    existing_organisation =
        AuthorityService::OrganisationsService.new.find_id(organisation)
    if existing_organisation.blank?
      create_organisation(organisation)
    else
      find_base(existing_organisation)
    end
  end

  # Create a Organisation object from the supplied string / orcid
  # If a Organisation for the orcid exists, update it
  def create_organisation(value)
    organisation = DogBiscuits::Organisation.new
    organisation.rdfs_label = value
    organisation.concept_scheme = find_concept_scheme('current_organisations')
    return organisation unless organisation.rdfs_label.blank?
  end

end

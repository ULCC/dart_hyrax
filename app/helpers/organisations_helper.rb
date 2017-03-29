# organisations Helper
module OrganisationsHelper

  # Find the Currentorganisation in Fedora
  #  if it doesn't exist create a new Currentorganisation
  def add_organisation(organisation)
    find_or_create_organisation(organisation)
  end

  def find_or_create_organisation(organisation)
    existing_organisation =
        AuthorityService::CurrentOrganisationService.new.find_id(organisation)
    if existing_organisation.blank?
      create_organisation(organisation)
    else
      find_base(existing_organisation)
    end
  end

  # Create a Currentorganisation object from the supplied string / orcid
  # If a Currentorganisation for the orcid exists, update it
  def create_organisation(value)
    organisation = DogBiscuits::CurrentOrganisation.new
    organisation.preflabel = value
    organisation.concept_scheme = find_concept_scheme('current_organisations')
    return organisation unless organisation.preflabel.blank?
  end

end

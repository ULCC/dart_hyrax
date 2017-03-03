# Creators Helper
module CreatorsHelper
  include OrcidHelper
  include LocalActorsHelper

  # Find the CurrentPerson in Fedora
  #  if it doesn't exist create a new CurrentPerson
  def add_person(creator)
    # is this an orcid?
    trimmed_value = trim_orcid_url(creator)
    if valid_orcid?(trimmed_value)
      find_or_create_orcid(creator)
    else
      find_or_create_person(creator)
    end
  end

  def find_or_create_person(creator)
    existing_person =
        AuthorityService::CurrentPersonService.new.find_id(creator)
    if existing_person.blank?
      create_person(creator)
    else
      find_base(existing_person)
    end
  end

  def find_or_create_orcid(creator)
    orcid_person = find_orcid(trim_orcid_url(creator))
    if orcid_person.blank?
      create_person_from_orcid(creator)
    else
      orcid_person
    end
  end

  # Create a CurrentPerson object from the supplied string / orcid
  # If a CurrentPerson for the orcid exists, update it
  def create_person(value)
    person = Dlibhydra::CurrentPerson.new
    person.preflabel = value
    person.concept_scheme = find_concept_scheme('current_people')
    return person unless person.preflabel.blank?
  end

  # Add data from ORCID to CurrentPerson object
  def create_person_from_orcid(creator)
    person = Dlibhydra::CurrentPerson.new
    person.concept_scheme = find_concept_scheme('current_people')
    bio = orcid_response(trim_orcid_url(creator))
    person.orcid = [trim_orcid_url(creator)]
    return add_orcid_details(person, bio) unless bio.blank?
  end

  def add_orcid_details(person, bio)
    pd = bio['orcid-bio']['personal-details']
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

  # If there is already a CurrentPerson for the given orcid, return it
  def find_orcid(person_orcid)
    response = query_solr_for_orcid(
        person_orcid,
        DLIBHYDRA['current_people']
    )
    numfound = response['response']['numFound']
    return find_base(response['response']['docs'][0]['id']) unless numfound == 0
  end

  # Setup a solr connection
  def setup_solr
    RSolr.connect url: ActiveFedora::FileConfigurator.new.solr_config[:url]
  end

  # Query solr for a current person with the given orcid
  # TODO: don't do the solr query like this, look for helper code
  def query_solr_for_orcid(orcid, scheme)
    setup_solr.get 'select', params: {
        q: 'inScheme_ssim:"' + scheme + '"',
        fq: 'orcid_tesim:"' + orcid + '"',
        fl: 'id'
    }
  end
end

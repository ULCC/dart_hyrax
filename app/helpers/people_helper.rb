# persons Helper
module PeopleHelper
  include OrcidHelper

  # Find the Person in Fedora
  #  if it doesn't exist create a new Person
  def add_person(person)
    # is this an orcid?
    trimmed_value = trim_orcid_url(person)
    if valid_orcid?(trimmed_value)
      find_or_create_orcid(person)
    else
      find_or_create_person(person)
    end
  end

  def find_or_create_person(person)
    existing_person =
        AuthorityService::PeopleService.new.find_id(person)
    if existing_person.blank?
      create_person(person)
    else
      find_base(existing_person)
    end
  end

  def find_or_create_orcid(person)
    orcid_person = find_orcid(trim_orcid_url(person))
    if orcid_person.blank?
      create_person_from_orcid(person)
    else
      orcid_person
    end
  end

  # Create a Person object from the supplied string / orcid
  # If a Person for the orcid exists, update it
  def create_person(value)
    person = DogBiscuits::Person.new
    person.rdfs_label = value
    person.concept_scheme = find_concept_scheme('people')
    return person unless person.rdfs_label.blank?
  end

  # Add data from ORCID to Person object
  def create_person_from_orcid(orcid)
    orcid_real = trim_orcid_url(orcid)
    person = DogBiscuits::Person.new
    person.concept_scheme = find_concept_scheme('people')
    bio = orcid_response(trim_orcid_url(orcid_real))
    person.orcid = [trim_orcid_url(orcid_real)]
    return add_orcid_details(person, bio) unless bio.blank?
  end

  def add_orcid_details(person, bio)
    pd = bio['orcid-bio']['personal-details']
    person.given_name = pd['given-names']['value']
    person.family_name = pd['family-name']['value']
    person.rdfs_label =
        "#{person.given_name}, #{person.family_name}"
    unless pd['other-names'].nil?
      person.altlabel =
          pd['other-names']['other-name'].collect { |o| o['value'] }
    end
    person
  end

  # If there is already a Person for the given orcid, return it
  def find_orcid(person_orcid)
    response = query_solr_for_orcid(
        person_orcid,
        DOGBISCUITS['people']
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

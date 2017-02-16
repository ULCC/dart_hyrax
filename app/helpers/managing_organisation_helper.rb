# Managing Organisation Helper
module ManagingOrganisationHelper
  include LocalActorsHelper

  # Return the managing organisation
  def find_managing_organisation
    org = YAML.load_file("#{Rails.root}/config/locales/hyrax.en.yml")['en']['hyrax']['institution_name']
    AuthorityService::CurrentOrganisationService.new.find_id(org)
  end

end

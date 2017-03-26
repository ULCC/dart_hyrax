# Managing Organisation Helper
module ManagingOrganisationHelper
  include LocalActorsHelper

  # Return the managing organisation
  def managing_organisation_id
    org = YAML.load_file("#{Rails.root}/config/locales/hyrax.en.yml")['en']['hyrax']['institution_name']
    managing_organisation_service.find_id(org)
  end

  def managing_organisation_label
    managing_organisation_service.find_value_string(find_managing_organisation)
  end

  def managing_organisation_service
    if @morg.nil?
      @morg = AuthorityService::CurrentOrganisationService.new
    else
      @morg
    end
  end

end

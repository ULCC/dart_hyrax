# Helper for local terms
module LocalHelper

  # TODO separate the two uses of these methods, one is from solr config and is from the renderer

  # A Local helper_method
  # @param [String] id
  # @return [String]
  def label_for_index(value)
    begin
      gimme_label(value[:document][value[:field]].first, value[:field].to_s.gsub('_tesim', ''))
    rescue
      nil
    end
  end

  def label_for_show(value, property)
    gimme_label(value,property)
  end

  # # A Local helper_method
  # # @param [String] from TODO
  # # @return [String]
  # def publication_status_string(value)
  #   if value.kind_of? String
  #     publication_status(value)
  #   elsif value.kind_of? Hash
  #     begin
  #       publication_status(value[:document]['publication_status_tesim'].first)
  #     rescue
  #       nil
  #     end
  #   else
  #     ERB::Util.h(value)
  #   end
  # end

  # A Local helper_method
  # @param [String] from TODO
  # @return [String]
  # def content_version_string(value)
  #   if value.kind_of? String
  #     content_version(value)
  #   elsif value.kind_of? Hash
  #     begin
  #       content_version(value[:document]['content_version_tesim'].first)
  #     rescue
  #       nil
  #     end
  #   else
  #     ERB::Util.h(value)
  #   end
  # end

  def refereed_string(value)
    if value.kind_of? String
      if value == 'true'
        'Yes'
      elsif value == 'false'
        'No'
      else
        'Unknown'
      end
    elsif value.kind_of? Hash
      begin
        if value[:document]['refereed_tesim'].first == 'true'
          'Yes'
        elsif value[:document]['refereed_tesim'].first == 'false'
          'No'
        else
          'Unknown'
        end
      rescue
        nil
      end
    else
      ERB::Util.h(value)
    end
  end

  private

  # def publication_status(value)
  #   begin
  #     parsed_uri = URI.parse(value)
  #   rescue
  #     nil
  #   end
  #   if parsed_uri.nil?
  #     ERB::Util.h(value)
  #   else
  #     ps_service = AuthorityService::PublicationStatusesService.new
  #     ERB::Util.h(ps_service.label(value))
  #   end
  # end

  # def content_version(value)
  #   begin
  #     parsed_uri = URI.parse(value)
  #   rescue
  #     nil
  #   end
  #   if parsed_uri.nil?
  #     ERB::Util.h(value)
  #   else
  #     cv_service = AuthorityService::JournalArticleVersionsService.new
  #     ERB::Util.h(cv_service.label(value))
  #   end
  # end

  def gimme_label(value, property)
    begin
      parsed_uri = URI.parse(value)
    rescue
      nil
    end
    if parsed_uri.nil?
      ERB::Util.h(value)
    else
      service = "AuthorityService::#{property.pluralize.camelize}Service".constantize.new
      ERB::Util.h(service.label(value))
    end
  end
end
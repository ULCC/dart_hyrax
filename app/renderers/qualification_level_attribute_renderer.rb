class QualificationLevelAttributeRenderer < Hyrax::Renderers::AttributeRenderer
  include LocalHelper
  private

  def attribute_value_to_html(value)
    link_to(label_for_show(value,'qualification_level'), search_path(value))
  end

  def search_path(value)
    Rails.application.routes.url_helpers.search_catalog_path(:"f[#{search_field}][]" => ERB::Util.h(value))
  end

  def search_field
    ERB::Util.h(Solrizer.solr_name(options.fetch(:search_field, field), :facetable, type: :string))
  end
end
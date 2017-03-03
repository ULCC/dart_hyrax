class RefereedAttributeRenderer < Hyrax::Renderers::AttributeRenderer
  include LocalHelper

  def attribute_value_to_html(value)
    refereed_string(value)
  end
end
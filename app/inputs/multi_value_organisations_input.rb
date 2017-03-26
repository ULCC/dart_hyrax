class MultiValueOrganisationsInput < MultiValueInput
  def input_type
    'multi_value'.freeze
  end

  private

  # translate the id into the label
  # use for cases where we can reliably get the id from the label (ie. local authorities)
  def build_field(value, index)
    options = build_field_options(value, index)
    co_service = AuthorityService::CurrentOrganisationService.new
    options[:value] = co_service.find_value_string(value)
    if options.delete(:type) == 'textarea'.freeze
      @builder.text_area(attribute_name, options)
    else
      @builder.text_field(attribute_name, options)
    end
  end

end
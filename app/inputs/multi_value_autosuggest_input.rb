class MultiValueAutosuggestInput < MultiValueInput
  def input_type
    'multi_value'.freeze
  end

  private

  def build_field(value, index)
    options = build_field_options(value, index)
    cp_service = AuthorityService::CurrentPersonService.new
    options[:value] = cp_service.find_value_string(value)
    if options.delete(:type) == 'textarea'.freeze
      @builder.text_area(attribute_name, options)
    else
      @builder.text_field(attribute_name, options)
    end
  end

end
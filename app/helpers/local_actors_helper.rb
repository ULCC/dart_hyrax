# Local Actors Helper
module LocalActorsHelper
  # Find the concept_scheme for the supplied scheme name
  def find_concept_scheme(scheme)
    Dlibhydra::ConceptScheme.find(DLIBHYDRA[scheme])
  rescue
    Rails.logger.error("Could not find the concept scheme for #{scheme}.")
  end

  def find_base(thing)
    ActiveFedora::Base.find(thing)
  rescue
    Rails.logger.error(
        "Could not find #{thing}."
    )
  end

  # Delete the specified attributes
  def trim_attributes(attributes, to_remove)
    to_remove.each { |a| attributes.delete(a) }
    attributes
  end
end

# Projects Helper
module ProjectsHelper
  include LocalActorsHelper

  # Create a Project object
  def create_project(name, identifier = nil)
    project = DogBiscuits::Project.new
    project.preflabel = name
    project.name = name
    project.identifier = [identifier] unless identifier.nil?
    project.concept_scheme = find_concept_scheme('projects')
    project
  end
end

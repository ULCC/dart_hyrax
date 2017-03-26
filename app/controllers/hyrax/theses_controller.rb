# Generated via
#  `rails generate hyrax:work Thesis`

module Hyrax
  class ThesesController < ApplicationController
    # Adds Hyrax behaviors to the controller.
    include Hyrax::WorksControllerBehavior
    include Hyrax::BreadcrumbsForWorks
    self.curation_concern_type = Thesis
    self.show_presenter = ThesisPresenter
  end
end

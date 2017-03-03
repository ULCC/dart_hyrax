# Generated via
#  `rails generate local:work JournalArticle`

module Hyrax
  class JournalArticlesController < ApplicationController
    # Adds Hyrax behaviors to the controller.
    include Hyrax::WorksControllerBehavior
    include Hyrax::BreadcrumbsForWorks
    self.curation_concern_type = JournalArticle
    self.show_presenter = JournalArticlesPresenter

  end
end

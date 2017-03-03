module Hyrax
  class FileSetsController < ApplicationController
    include Hyrax::FileSetsControllerBehavior
    self.show_presenter = LocalFileSetPresenter
  end
end

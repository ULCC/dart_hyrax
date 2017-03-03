# Generated via
#  `rails generate local:work Book`
module Hyrax
  class BookForm < Hyrax::Forms::WorkForm
    self.model_class = ::Book
    self.terms += [:resource_type]
  end
end

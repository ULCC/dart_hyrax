# Generated via
#  `rails generate hyrax:work JournalArticle`
module Hyrax
  class JournalArticleForm < Hyrax::Forms::WorkForm
    self.model_class = ::JournalArticle
    self.terms += [:resource_type]
    #self.required_fields = [:title]

  end
end

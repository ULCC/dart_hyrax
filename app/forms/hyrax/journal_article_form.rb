# Generated via
#  `rails generate hyrax:work JournalArticle`
module Hyrax
  class JournalArticleForm < Hyrax::Forms::WorkForm
    self.model_class = ::JournalArticle

    # remove things with
    self.terms -= [:title, :creator, :contributor, :description,
                   :keyword, :rights, :publisher, :date_created, :subject, :language,
                   :identifier, :based_near, :related_url, :source]

    # JA I don't know why :resource_type is added in here by default
    self.terms += [:resource_type]
    # remove the + to replace the whole set (necessary if you want to affect the order)
    self.terms += [:title, :creator_resource_ids, :creator_string, :doi,:journal_resource_ids,
                   :volume_number,:issue_number,  :pagination,
                   :date_published, :date_available, :date_accepted, :date_submitted,
                   :abstract, :department_resource_ids,:publication_status, :refereed,:language,
                   :subject_resource_ids,:keyword,:official_url,:related_url,
                   :funder_resource_ids, :project_resource_ids]

    self.required_fields = [:title]
    self.required_fields -= [:creator, :keyword, :rights]
    self.required_fields -= [:creator, :keyword]

  end
end

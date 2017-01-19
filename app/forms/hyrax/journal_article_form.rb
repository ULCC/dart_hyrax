# Generated via
#  `rails generate hyrax:work JournalArticle`
module Hyrax
  class JournalArticleForm < Hyrax::Forms::WorkForm
    self.model_class = ::JournalArticle

    # remove things with
    self.terms -= [:title, :creator, :contributor, :description,
                   :keyword, :rights, :publisher, :date_created, :subject, :language,
                   :identifier, :based_near, :related_url, :source]

    # self.terms += [:resource_type]
    # use + to replace the whole set of terms
    # this defines form order
    self.terms += [:title,
                   :doi, # auto-populate other metadata
                   :creator_resource_ids,
                   :creator_string,
                   # :journal_resource_ids, table-based?
                   :volume_number, # smaller, with issue
                   :issue_number, # smaller, with issue
                   :pagination,
                   :date_published, # reformat, with next three
                   :date_available,
                   :date_accepted,
                   :date_submitted,
                   :abstract,
                   :official_url, # check for valid url
                   :publication_status, # file-based
                   :refereed, # buttons, true, false or unknown
                   :language, # table-based
                   :department_resource_ids, # object-based
                   :subject_resource_ids, # object-based???
                   :keyword,
                   :related_url, # check for valid url
    # :funder_resource_ids, table-based ?
    # :project_resource_ids, # some kind of list, file, table or object
    # :managing_organisation_ids # default value; object
    ]

    self.required_fields = [:title]
    self.required_fields -= [:creator, :keyword, :rights]
    self.required_fields -= [:creator, :keyword]

  end
end

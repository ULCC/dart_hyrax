# Generated via
#  `rails generate local:work JournalArticle`
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
                   :doi, # auto-populate other metadata with crossref lookup
                   :creator_resource_ids,
                   # :orcid, # add to creator_resource_ids
                   :journal, # auto-suggest with crossref
                   :volume_number, # smaller, with issue
                   :issue_number, # smaller, with issue
                   :pagination, # smaller,
                   :date_published, # TODO smaller, date picker/formatter, ideally combine with next three
                   :date_available,
                   :date_accepted,
                   :date_submitted,
                   :abstract, # larger
                   :official_url, # check for valid url
                   :publication_status, # file-based
                   :refereed, # buttons, true, false or unknown
                   :language, # table-based
                   :department_resource_ids, # object-based
                   :subject, # auto-suggest with FAST
                   :keyword,
                   :funder, # auto-suggest with crossref
                   :project_resource_ids, # object-based
                   :project_name, # not stored, used to create a project object
                   :project_identifier, # not stored, used to create a project object
                   :related_url, # check for valid url
    ]

    self.required_fields = [:title, :publication_status, :refereed, :creator_resource_ids, :department_resource_ids]
    self.required_fields -= [:creator, :keyword, :rights]

  end
end

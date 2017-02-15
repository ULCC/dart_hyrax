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
                   # :orcid,
                   # :journal_resource_ids, table-based? auto-add publisher
                   :journal, # auto-suggest with crossref
                   :volume_number, # smaller, with issue
                   :issue_number, # smaller, with issue
                   :pagination, # smaller,
                   :date_published, # smaller, date picker/formatter, ideally combine with next three
                   :date_available,
                   :date_accepted,
                   :date_submitted,
                   :abstract, # larger
                   :official_url, # check for valid url
                   :publication_status, # file-based
                   :refereed, # buttons, true, false or unknown
                   :language, # table-based
                   :department_resource_ids, # object-based
                   :subject, # auto-suggest with FAST (removed _resource_ids)
                   :keyword,
                   :funder,
                   :project_resource_ids,
                   :project_name,
                   :project_identifier,
                   :related_url, # check for valid url
    # :managing_organisation_ids # default value; object
    ]

    self.required_fields = [:title, :publication_status, :refereed, :creator_resource_ids]
    self.required_fields -= [:creator, :keyword, :rights]

  end
end

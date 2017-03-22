# Generated via
#  `rails generate hyrax:work Thesis`
module Hyrax
  class ThesisForm < Hyrax::Forms::WorkForm
    self.model_class = ::Thesis

    # remove things
    self.terms -= [:title, :creator, :contributor, :description,
                   :keyword, :rights, :publisher, :date_created, :subject, :language,
                   :identifier, :based_near, :related_url, :source]

    #self.terms += [:resource_type]

    # add things in order
    self.terms += [:title,
                   :creator_resource_ids,
                   :date_of_award,
                   :awarding_institution_resource_ids,
                   :department_resource_ids, # object-based
                   :qualification_level, # file-based
                   :qualification_name, # file-based
                   :rights,
                   :advisor_resource_ids, # object-based
                   :abstract, # larger
                   :language, # table-based
                   :subject, # auto-suggest with FAST
                   :keyword,
                   :related_url, # check for valid url
    ]

    self.required_fields = [:title, :creator_resource_ids, :department_resource_ids, :qualification_level, :qualification_name, :date_of_award]
    #, :awarding_institution_resource_ids]
    self.required_fields -= [:creator, :keyword]

  end
end

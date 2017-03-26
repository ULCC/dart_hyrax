# app/presenters/thesis_presenter.rb
class ThesisPresenter < Hyrax::WorkShowPresenter

  # these correspond to the method names in solr_document.rb
  delegate :abstract, :creator_value, :department, :subject, :awarding_institution,
           :date_of_award, :qualification_level, :qualification_name, :advisor,
           to: :solr_document

end
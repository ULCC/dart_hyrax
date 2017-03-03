# app/presenters/journal_articles_presenter.rb
class JournalArticlesPresenter < Hyrax::WorkShowPresenter

  # these correspond to the method names in solr_document.rb
  delegate :abstract, :creator_value, :funder, :project, :department, :subject, :journal, :publisher,
           :date_available, :date_published, :date_submitted, :date_accepted, :managing_organisation,
           :publication_status, :refereed, :official_url, :volume_number, :issue_number, :pagination, :doi,
           to: :solr_document

  def member_presenter_factory
    LocalMemberPresenterFactory.new(solr_document, current_ability, request)
  end

end
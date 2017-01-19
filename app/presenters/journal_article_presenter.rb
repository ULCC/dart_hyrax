# app/presenters/journal_article_presenter.rb
class JournalArticlePresenter < Hyrax::WorkShowPresenter

  # these correspond to the method names in solr_document.rb
  delegate :abstract, :creator, :funder, :project, :department, :subject, :journal,
           :date_available, :date_published, :date_submitted, :date_accepted,
           :publication_status, :refereed, :official_url, :volume_number, :issue_number, :pagination, :doi,
           to: :solr_document
end
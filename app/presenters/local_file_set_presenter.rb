class LocalFileSetPresenter < Hyrax::FileSetPresenter

  # Metadata Methods
  delegate :title, :label, :description, :creator, :contributor, :subject,
           :publisher, :language, :date_uploaded, :rights,
           :embargo_release_date, :lease_expiration_date,
           :depositor, :keyword, :title_or_label, :depositor, :keyword,
           :date_created, :date_modified, :itemtype,
           :content_version,
           to: :solr_document

  def content_version
    return if solr_document.content_version.nil?
    solr_document.content_version.first
  end
end
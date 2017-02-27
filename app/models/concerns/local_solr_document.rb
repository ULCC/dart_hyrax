module LocalSolrDocument
  extend ActiveSupport::Concern

  # TODO alphebetize
    included do

      def abstract
        self[Solrizer.solr_name('abstract')]
      end

      def content_version
        self[Solrizer.solr_name('content_version')]
      end

      def creator
        self[Solrizer.solr_name('creator')]
      end

      def creator_value
        self[Solrizer.solr_name('creator_value')]
      end

      def date
        self[Solrizer.solr_name('date')]
      end

      def department
        self[Solrizer.solr_name('department_value')]
      end

      def funder
        self[Solrizer.solr_name('funder')]
      end

      def project
        self[Solrizer.solr_name('project_value')]
      end

      def publisher
        self[Solrizer.solr_name('publisher')]
      end

      def journal
        self[Solrizer.solr_name('journal')]
      end

      def date_available
        self[Solrizer.solr_name('date_available')]
      end

      def date_published
        self[Solrizer.solr_name('date_published')]
      end

      def date_submitted
        self[Solrizer.solr_name('date_submitted')]
      end

      def date_accepted
        self[Solrizer.solr_name('date_accepted')]
      end

      def publication_status
        self[Solrizer.solr_name('publication_status')]
      end

      def refereed
        self[Solrizer.solr_name('refereed')]
      end

      def official_url
        self[Solrizer.solr_name('official_url')]
      end

      def subject
        self[Solrizer.solr_name('subject')]
      end

      def language
        self[Solrizer.solr_name('language')]
      end

      def issue_number
        self[Solrizer.solr_name('issue_number')]
      end

      def volume_number
        self[Solrizer.solr_name('volume_number')]
      end

      def pagination
        self[Solrizer.solr_name('pagination')]
      end

      def doi
        self[Solrizer.solr_name('doi')]
      end

      def managing_organisation
        self[Solrizer.solr_name('managing_organisation_value')]
      end

    end
end

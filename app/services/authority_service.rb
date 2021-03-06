module AuthorityService

# Object based
	class ProjectService < Dlibhydra::Terms::ProjectTerms
		include ::LocalAuthorityConcern
	end
	class JournalService < Dlibhydra::Terms::JournalTerms
		include ::LocalAuthorityConcern
	end
	class SubjectService < Dlibhydra::Terms::SubjectTerms
		include ::LocalAuthorityConcern
	end
	class CurrentOrganisationService < Dlibhydra::Terms::CurrentOrganisationTerms
		include ::LocalAuthorityConcern
	end
	class CurrentPersonService < Dlibhydra::Terms::CurrentPersonTerms
		include ::LocalAuthorityConcern
	end
	class DepartmentService < Dlibhydra::Terms::DepartmentTerms
		include ::LocalAuthorityConcern
	end

# File based
	class RightsStatementsService < Hyrax::QaSelectService
	include ::FileAuthorityConcern
		def initialize
			super('rights_statements')
		end
	end
	class ResourceTypesService < Hyrax::QaSelectService
	include ::FileAuthorityConcern
		def initialize
			super('resource_types')
		end
	end
  class QualificationNamesService < Hyrax::QaSelectService
    include ::FileAuthorityConcern

    def initialize
      super('qualification_names')
    end
  end
	class QualificationLevelsService < Hyrax::QaSelectService
	include ::FileAuthorityConcern
		def initialize
			super('qualification_levels')
		end
	end
	class PublicationStatusesService < Hyrax::QaSelectService
	include ::FileAuthorityConcern
		def initialize
			super('publication_statuses')
		end
	end
	class LicensesService < Hyrax::QaSelectService
	include ::FileAuthorityConcern
		def initialize
			super('licenses')
		end
	end
	class LanguagesService < Hyrax::QaSelectService
	include ::FileAuthorityConcern
		def initialize
			super('languages')
		end
	end
	class JournalArticleVersionsService < Hyrax::QaSelectService
	include ::FileAuthorityConcern
		def initialize
			super('journal_article_versions')
		end
	end

end
require_relative 'downloader'
require 'rdf/rdfxml'
module Hyrax
  module ControlledVocabulary
    module Importer
      class Funder
        URL = 'http://dx.doi.org/10.13039/fundref_registry'.freeze

        def initialize
          stdout_logger = Logger.new(STDOUT)
          stdout_logger.level = Logger::INFO
          stdout_logger.formatter = proc do |_severity, _datetime, _progname, msg|
            "#{msg}\n"
          end
          Rails.logger.extend(ActiveSupport::Logger.broadcast(stdout_logger))
        end

        def import
          download
          logger.info "Importing #{rdf_path}"
          # Qa::Services::RDFAuthorityParser.import_rdf(
          #     'languages',
          #     [rdf_path],
          #     format: 'rdfxml',
          #     predicate: RDF::URI('http://www.w3.org/2008/05/skos#prefLabel')
          # )
          logger.info "Import complete"
        end

        delegate :logger, to: Rails

        def rdf_path
          @rdf_path ||= download_path
        end

        def download
          return if File.exist?(rdf_path) || File.exist?(download_path)
          logger.info "Downloading #{URL}"
          Downloader.fetch(URL, download_path)
        end

        def download_path
          File.join(download_dir, File.basename(URL))
        end

        def download_dir
          @download_dir ||= Rails.root.join('tmp')
          FileUtils.mkdir_p @download_dir
          @download_dir
        end
      end
    end
  end
end

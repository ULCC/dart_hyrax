require_relative 'downloader'
require 'rdf/rdfxml'
require 'open-uri'

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
          @authority = Qa::LocalAuthority.find_or_create_by(name: 'funders')
          parse_funders
          # this is where my code comes in
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

        def parse_funders
          fundref = Nokogiri::XML(File.read(rdf_path))
          @concepts = fundref.css('skos|Concept')
          @countries = Hash.new
          parse_concepts
        end

        def parse_concepts
          @concepts.each do |node|

            # skip 'renamedAs' entries
            unless node.at_css('svf|renamedAs')
              value = "#{node.css('skosxl|prefLabel').
                  css('skosxl|Label').
                  css('skosxl|literalForm').text}"

              node.css('skosxl|altLabel').each do |alt|
                alt.css('skosxl|Label').each do |label|

                  if label.at_css('fref|usageFlag') and
                      label.css('fref|usageFlag').attr('resource').text ==
                          'http://data.crossref.org/fundingdata/vocabulary/abbrevName'

                    value += " (#{label.css('skosxl|literalForm').text})"
                  end
                end
              end
              if node.at_css('svf|country')
                country = node.css('svf|country').attr('resource').text
                unless @countries[country]
                  retrieve_from_geonames(country)
                end
                value += " [#{@countries[country]}" if @countries[country]
                if node.at_css('svf|state')
                  state = node.css('svf|state').attr('resource').text
                  unless @countries[state]
                    retrieve_from_geonames(state)
                  end
                  value += ", #{@countries[state]}" if @countries[state]
                end
                value += ']'
              end
              create(value,node.attr('rdf:about'))

            end
          end
        end

        def retrieve_from_geonames(place)
          geoname = Nokogiri::XML(open("#{place}about.rdf"))
          @countries[place] = geoname.css('gn|name').text
          rescue
            Rails.logger.warn("Couldn't retrieve: #{place}")
        end

        def create(value, uri)
          Qa::LocalAuthorityEntry.create(
              local_authority: @authority,
              label: value,
              uri: uri)
          rescue ActiveRecord::RecordNotUnique
            Rails.logger.warn("Duplicate record: #{uri}")
        end
      end
    end
  end
end

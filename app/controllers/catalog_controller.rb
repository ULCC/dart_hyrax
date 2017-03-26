# -*- encoding : utf-8 -*-
require 'blacklight/catalog'

class CatalogController < ApplicationController

  include Hydra::Catalog
  # This filter applies the hydra access controls
  before_action :enforce_show_permissions, only: :show

  configure_blacklight do |config|
    config.view.gallery.partials = [:index_header, :index]
    config.view.masonry.partials = [:index]
    config.view.slideshow.partials = [:index]


    config.show.tile_source_field = :content_metadata_image_iiif_info_ssm
    config.show.partials.insert(1, :openseadragon)
    ## Class for sending and receiving requests from a search index
    # config.repository_class = Blacklight::Solr::Repository
    #
    ## Class for converting Blacklight's url parameters to into request parameters for the search index
    # config.search_builder_class = ::SearchBuilder
    #
    ## Model that maps search index responses to the blacklight response model
    # config.response_model = Blacklight::Solr::Response

    ## Default parameters to send to solr for all search-like requests. See also SearchBuilder#processed_parameters
    ## Default parameters to send to solr for all search-like requests. See also SolrHelper#solr_search_params
    config.default_solr_params = {
        qt: "search",
        rows: 10,
        qf: "title_tesim " +
            "doi_tesim " +
            "creator_tesim" +
            "creator_value_tesim " +
            "journal_tesim " +
            "date_tesim " +
            "abstract_tesim " +
            "publication_status_tesim " +
            "refereed_tesim " +
            "language_tesim " +
            "department_value_tesim " +
            "subject_tesim " +
            "keyword_tesim " +
            "funder_tesim " +
            "project_value_tesim"
        # TODO add more
    }

    # solr field configuration for search results/index views
    config.index.title_field = 'title_tesim'
    config.index.display_type_field = 'has_model_ssim'


    # solr fields that will be treated as facets by the blacklight application
    #   The ordering of the field names is the order of the display
    #
    # Setting a limit will trigger Blacklight's 'more' facet values link.
    # * If left unset, then all facet values returned by solr will be displayed.
    # * If set to an integer, then "f.somefield.facet.limit" will be added to
    # solr request, with actual solr request being +1 your configured limit --
    # you configure the number of items you actually want _tsimed_ in a page.
    # * If set to 'true', then no additional parameters will be sent to solr,
    # but any 'sniffed' request limit parameters will be used for paging, with
    # paging at requested limit -1. Can sniff from facet.limit or
    # f.specific_field.facet.limit solr request params. This 'true' config
    # can be used if you set limits in :default_solr_params, or as defaults
    # on the solr side in the request handler itself. Request handler defaults
    # sniffing requires solr requests to be made with "echoParams=all", for
    # app code to actually have it echo'd back to see it.
    #
    # :show may be set to false if you don't want the facet to be drawn in the
    # facet bar
    # config.add_facet_field solr_name('object_type', :facetable), label: 'Format'
    # config.add_facet_field solr_name('pub_date', :facetable), label: 'Publication Year'
    # config.add_facet_field solr_name('subject_topic', :facetable), label: 'Topic', limit: 20
    # config.add_facet_field solr_name('language', :facetable), label: 'Language', limit: true
    # config.add_facet_field solr_name('lc1_letter', :facetable), label: 'Call Number'
    # config.add_facet_field solr_name('subject_geo', :facetable), label: 'Region'
    # config.add_facet_field solr_name('subject_era', :facetable), label: 'Era'

    #   The ordering of the field names is the order of the display
    config.add_facet_field solr_name("human_readable_type", :facetable), label: "Type", limit: 5
    config.add_facet_field solr_name("resource_type", :facetable), label: "Resource Type", limit: 5
    #config.add_facet_field solr_name("creator", :facetable), label: "Creator", limit: 5
    config.add_facet_field solr_name("contributor", :facetable), label: "Contributor", limit: 5
    config.add_facet_field solr_name("keyword", :facetable), label: "Keyword", limit: 5
    config.add_facet_field solr_name("subject", :facetable), label: "Subject", limit: 5
    config.add_facet_field solr_name("language", :facetable), label: "Language", limit: 5
    config.add_facet_field solr_name("based_near", :facetable), label: "Location", limit: 5
    config.add_facet_field solr_name("publisher", :facetable), label: "Publisher", limit: 5
    config.add_facet_field solr_name("file_format", :facetable), label: "File Format", limit: 5
    config.add_facet_field solr_name('member_of_collections', :symbol), limit: 5, label: 'Collections'

    # Journal Article
    config.add_facet_field solr_name("department_value", :facetable), label: "Department, Research Centre or other unit"
    config.add_facet_field solr_name("date", :facetable), label: "Dates"
    config.add_facet_field solr_name("refereed", :facetable), label: "Refereed", helper_method: :refereed_string
    config.add_facet_field solr_name("publication_status", :facetable), label: "Publication Status", helper_method: :label_for_index
    config.add_facet_field solr_name("creator_value", :facetable), label: "Creator", limit: 5
    config.add_facet_field solr_name("funder", :facetable), label: "Funder", limit: 5
    config.add_facet_field solr_name("project_value", :facetable), label: "Project", limit: 5

    # Have BL send all facet field names to Solr, which has been the default
    # previously. Simply remove these lines if you'd rather use Solr request
    # handler defaults, or have no facets.
    config.default_solr_params[:'facet.field'] = config.facet_fields.keys
    #use this instead if you don't want to query facets marked :show=>false
    #config.default_solr_params[:'facet.field'] = config.facet_fields.select{ |k, v| v[:show] != false}.keys


    # solr fields to be displayed in the index (search results) view
    #   The ordering of the field names is the order of the display
    # config.add_index_field solr_name('title', :stored_searchable, type: :string), label: 'Title'
    # config.add_index_field solr_name('title_vern', :stored_searchable, type: :string), label: 'Title'
    # config.add_index_field solr_name('author', :stored_searchable, type: :string), label: 'Author'
    # config.add_index_field solr_name('author_vern', :stored_searchable, type: :string), label: 'Author'
    # config.add_index_field solr_name('format', :symbol), label: 'Format'
    # config.add_index_field solr_name('language', :stored_searchable, type: :string), label: 'Language'
    # config.add_index_field solr_name('published', :stored_searchable, type: :string), label: 'Published'
    # config.add_index_field solr_name('published_vern', :stored_searchable, type: :string), label: 'Published'
    # config.add_index_field solr_name('lc_callnum', :stored_searchable, type: :string), label: 'Call number'

    # solr fields to be displayed in the show (single result) view
    #   The ordering of the field names is the order of the display
    # config.add_show_field solr_name('title', :stored_searchable, type: :string), label: 'Title'
    # config.add_show_field solr_name('title_vern', :stored_searchable, type: :string), label: 'Title'
    # config.add_show_field solr_name('subtitle', :stored_searchable, type: :string), label: 'Subtitle'
    # config.add_show_field solr_name('subtitle_vern', :stored_searchable, type: :string), label: 'Subtitle'
    # config.add_show_field solr_name('author', :stored_searchable, type: :string), label: 'Author'
    # config.add_show_field solr_name('author_vern', :stored_searchable, type: :string), label: 'Author'
    # config.add_show_field solr_name('format', :symbol), label: 'Format'
    # config.add_show_field solr_name('url_fulltext_tsim', :stored_searchable, type: :string), label: 'URL'
    # config.add_show_field solr_name('url_suppl_tsim', :stored_searchable, type: :string), label: 'More Information'
    # config.add_show_field solr_name('language', :stored_searchable, type: :string), label: 'Language'
    # config.add_show_field solr_name('published', :stored_searchable, type: :string), label: 'Published'
    # config.add_show_field solr_name('published_vern', :stored_searchable, type: :string), label: 'Published'
    # config.add_show_field solr_name('lc_callnum', :stored_searchable, type: :string), label: 'Call number'
    # config.add_show_field solr_name('isbn', :stored_searchable, type: :string), label: 'ISBN'

    # solr fields to be displayed in the index (search results) view
    #   The ordering of the field names is the order of the display
    config.add_index_field solr_name("title", :stored_searchable), label: "Title", itemprop: 'name', if: false
    #config.add_index_field solr_name("description", :stored_searchable), label: "Description", itemprop: 'description', helper_method: :iconify_auto_link
    #config.add_index_field solr_name("abstract", :stored_searchable), label: "Abstract", itemprop: 'abstract', helper_method: :iconify_auto_link
    #config.add_index_field solr_name("keyword", :stored_searchable), label: "Keyword", itemprop: 'keywords', link_to_search: solr_name("keyword", :facetable)
    #config.add_index_field solr_name("subject", :stored_searchable), label: "Subject", itemprop: 'about', link_to_search: solr_name("subject", :facetable)
    #config.add_index_field solr_name("creator", :stored_searchable), label: "Creator", itemprop: 'creator', link_to_search: solr_name("creator", :facetable)
    #config.add_index_field solr_name("contributor", :stored_searchable), label: "Contributor", itemprop: 'contributor', link_to_search: solr_name("contributor", :facetable)
    #config.add_index_field solr_name("proxy_depositor", :symbol), label: "Depositor", helper_method: :link_to_profile
    #config.add_index_field solr_name("depositor"), label: "Owner", helper_method: :link_to_profile
    #config.add_index_field solr_name("publisher", :stored_searchable), label: "Publisher", itemprop: 'publisher', link_to_search: solr_name("publisher", :facetable)
    #config.add_index_field solr_name("based_near", :stored_searchable), label: "Location", itemprop: 'contentLocation', link_to_search: solr_name("based_near", :facetable)
    #config.add_index_field solr_name("language", :stored_searchable), label: "Language", itemprop: 'inLanguage', link_to_search: solr_name("language", :facetable)
    #config.add_index_field solr_name("date_uploaded", :stored_sortable, type: :date), label: "Date Uploaded", itemprop: 'datePublished', helper_method: :human_readable_date
    #config.add_index_field solr_name("date_modified", :stored_sortable, type: :date), label: "Date Modified", itemprop: 'dateModified', helper_method: :human_readable_date
    #config.add_index_field solr_name("date_created", :stored_searchable), label: "Date Created", itemprop: 'dateCreated'
    #config.add_index_field solr_name("rights", :stored_searchable), label: "Rights", helper_method: :license_links
    #config.add_index_field solr_name("resource_type", :stored_searchable), label: "Resource Type", link_to_search: solr_name("resource_type", :facetable)
    config.add_index_field solr_name("file_format", :stored_searchable), label: "File Format", link_to_search: solr_name("file_format", :facetable)
    #config.add_index_field solr_name("identifier", :stored_searchable), label: "Identifier", helper_method: :index_field_link, field_name: 'identifier'
    config.add_index_field solr_name("embargo_release_date", :stored_sortable, type: :date), label: "Embargo release date", helper_method: :human_readable_date
    config.add_index_field solr_name("lease_expiration_date", :stored_sortable, type: :date), label: "Lease expiration date", helper_method: :human_readable_date

    # Journal Article
    config.add_index_field solr_name("creator_value", :stored_searchable), label: "Creator", itemprop: 'creator_value', link_to_search: solr_name("creator_value", :facetable)
    config.add_index_field solr_name("department_value", :stored_searchable), label: "Department, Research Centre or other unit", itemprop: 'creator_value', link_to_search: solr_name("department_value", :facetable)
    config.add_index_field solr_name("refereed", :stored_searchable), label: "Refereed", helper_method: :refereed_string
    config.add_index_field solr_name("publication_status", :stored_searchable), label: "Publication status", helper_method: :label_for_index
    config.add_index_field solr_name("journal", :stored_searchable), label: "Journal", itemprop: 'journal', link_to_search: solr_name("journal", :facetable)
    config.add_index_field solr_name("funder", :stored_searchable), label: "Funder", itemprop: 'funder', link_to_search: solr_name("funder", :facetable)
    config.add_index_field solr_name("language", :stored_searchable), label: "Language", itemprop: 'inLanguage', link_to_search: solr_name("language", :facetable)
    config.add_index_field solr_name("content_version", :stored_searchable), itemprop: 'version', link_to_search: solr_name("content_version", :facetable)

    # Thesis
    config.add_index_field solr_name("qualification_level", :stored_searchable), label: "Qualification level", helper_method: :label_for_index
    config.add_index_field solr_name("qualification_name", :stored_searchable), label: "Qualification name", helper_method: :label_for_index

    # solr fields to be displayed in the show (single result) view
    # The ordering of the field names is the order of the display
    config.add_show_field solr_name("title", :stored_searchable), label: "Title"
    config.add_show_field solr_name("description", :stored_searchable), label: "Description"
    config.add_show_field solr_name("keyword", :stored_searchable), label: "Keyword"
    #config.add_show_field solr_name("subject", :stored_searchable), label: "Subject"
    #config.add_show_field solr_name("creator", :stored_searchable), label: "Creator"
    #config.add_show_field solr_name("contributor", :stored_searchable), label: "Contributor"
    config.add_show_field solr_name("publisher", :stored_searchable), label: "Publisher"
    #config.add_show_field solr_name("based_near", :stored_searchable), label: "Location"
    config.add_show_field solr_name("language", :stored_searchable), label: "Language"
    config.add_show_field solr_name("date_uploaded", :stored_searchable), label: "Date Uploaded"
    config.add_show_field solr_name("date_modified", :stored_searchable), label: "Date Modified"
    config.add_show_field solr_name("date_created", :stored_searchable), label: "Date Created"
    config.add_show_field solr_name("rights", :stored_searchable), label: "Rights"
    #config.add_show_field solr_name("resource_type", :stored_searchable), label: "Resource Type"
    config.add_show_field solr_name("format", :stored_searchable), label: "File Format"
    config.add_show_field solr_name("identifier", :stored_searchable), label: "Identifier"

    # Journal Article
    config.add_show_field solr_name("creator_value", :stored_searchable), label: "Creator"
    config.add_show_field solr_name("department_value", :stored_searchable), label: "Department, Research Centre or other unit"
    config.add_show_field solr_name("journal", :stored_searchable), label: "Journal"
    config.add_show_field solr_name("abstract", :stored_searchable), label: "Abstract"
    config.add_show_field solr_name("date_published", :stored_searchable), label: "Date Published"
    config.add_show_field solr_name("date_available", :stored_searchable), label: "Date Available"
    config.add_show_field solr_name("date_accepted", :stored_searchable), label: "Date Accepted"
    config.add_show_field solr_name("date_submitted", :stored_searchable), label: "Date Submitted"
    config.add_show_field solr_name("refereed", :stored_searchable), label: "Refereed"
    config.add_show_field solr_name("publication_status", :stored_searchable), label: "Publication Status"
    config.add_show_field solr_name("volume_number", :stored_searchable), label: "Volume"
    config.add_show_field solr_name("issue_number", :stored_searchable), label: "Issue"
    config.add_show_field solr_name("official_url", :stored_searchable), label: "Official URL"
    config.add_show_field solr_name("pagination", :stored_searchable), label: "Pages"
    config.add_show_field solr_name("doi", :stored_searchable), label: "DOI"
    config.add_show_field solr_name("subject", :stored_searchable), label: "Subject"
    config.add_show_field solr_name("funder", :stored_searchable), label: "Funder"
    config.add_show_field solr_name("project_value", :stored_searchable), label: "Related project"
    config.add_show_field solr_name("managing_organisation_value", :stored_searchable), label: "Managing Organisation"

    # Thesis



    # "fielded" search configuration. Used by pulldown among other places.
    # For supported keys in hash, see rdoc for Blacklight::SearchFields
    #
    # Search fields will inherit the :qt solr request handler from
    # config[:default_solr_parameters], OR can specify a different one
    # with a :qt key/value. Below examples inherit, except for subject
    # that specifies the same :qt as default for our own internal
    # testing purposes.
    #
    # The :key is what will be used to identify this BL search field internally,
    # as well as in URLs -- so changing it after deployment may break bookmarked
    # urls.  A display label will be automatically calculated from the :key,
    # or can be specified manually to be different.

    # This one uses all the defaults set by the solr request handler. Which
    # solr request handler? The one set in config[:default_solr_parameters][:qt],
    # since we aren't specifying it otherwise.

    config.add_search_field 'all_fields', label: 'All Fields'


    # Now we see how to over-ride Solr request handler defaults, in this
    # case for a BL "search field", which is really a dismax aggregate
    # of Solr search fields.

    config.add_search_field('title') do |field|
      # :solr_local_parameters will be sent using Solr LocalParams
      # syntax, as eg {! qf=$title_qf }. This is neccesary to use
      # Solr parameter de-referencing like $title_qf.
      # See: http://wiki.apache.org/solr/LocalParams
      field.solr_local_parameters = {
          qf: '$title_qf',
          pf: '$title_pf'
      }
    end

    config.add_search_field('author') do |field|
      field.solr_local_parameters = {
          qf: '$author_qf',
          pf: '$author_pf'
      }
    end

    # Specifying a :qt only to show it's possible, and so our internal automated
    # tests can test it. In this case it's the same as
    # config[:default_solr_parameters][:qt], so isn't actually neccesary.
    config.add_search_field('subject') do |field|
      field.qt = 'search'
      field.solr_local_parameters = {
          qf: '$subject_qf',
          pf: '$subject_pf'
      }
    end

    # "sort results by" select (pulldown)
    # label in pulldown is followed by the name of the SOLR field to sort by and
    # whether the sort is ascending or descending (it must be asc or desc
    # except in the relevancy case).
    config.add_sort_field 'score desc, pub_date_dtsi desc, title_tesi asc', label: 'relevance'
    config.add_sort_field 'pub_date_dtsi desc, title_tesi asc', label: 'year'
    config.add_sort_field 'author_tesi asc, title_tesi asc', label: 'author'
    config.add_sort_field 'title_tesi asc, pub_date_dtsi desc', label: 'title'

    # If there are more than this many search results, no spelling ("did you
    # mean") suggestion is offered.
    config.spell_max = 5
  end


end

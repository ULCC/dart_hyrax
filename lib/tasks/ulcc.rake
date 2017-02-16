namespace :ulcc do

  SOLR = 'http://127.0.0.1:8983/solr/hydra-development'

  desc "TODO"
  task :make_me_admin, [:email] => [:environment] do |t, args|

    if args[:email].nil?
      puts 'Supply the email address that you want to make an administrator, like this'
      puts "rake ulcc:make_me_admin['person@wherever.com']"

    elsif args[:email].include? '@'
      begin
        admin = Role.create(name: "admin")
        # if the role already exists, this will be nil
        if admin.id.nil?
          admin = Role.find_by(name: 'admin')
        end
        admin.users << User.find_by_user_key( args[:email] )
        admin.save
        puts "#{args[:email]} is now an admin: #{User.find_by_user_key( args[:email] ).admin?}"
        puts 'All Done.'
      rescue
        puts 'Something went wrong. Check that the email already has an account.'
      end
    else
      puts 'Invalid email address'
    end
  end

  desc "Deletes any unused Hydra::AccessControl objects"
  task cleanup_accesscontrol: :environment do
    Hydra::AccessControl.all.each do | access_control|
      if access_control.contains == []
        puts "Deleting #{access_control.id}"
        access_control.destroy.eradicate
      end
    end
  end

  desc "Load fundref data into database"
  task load_fundref: :environment do
    require 'hyrax/controlled_vocabulary/importer/funder'
    Hyrax::ControlledVocabulary::Importer::Funder.new.import
    # Insert at end of config/initializers/hyrax.rb
    # Qa::Authorities::Local.register_subauthority('funders', 'Qa::Authorities::Local::TableBasedAuthority')
  end

  desc "load_terms"
  task load_terms: :environment do

  SOLR = 'http://localhost:8983/solr/hydra-development'


    # path = Rails.root + 'lib/'
    # .csv files should exist in the specified path
    # filename will be the name of the concept scheme
    list = []
    list.each do |i|

      begin
        scheme = ''
        solr = RSolr.connect :url => SOLR
        response = solr.get 'select', :params => {
            :q=>"preflabel_tesim:#{i} AND has_model_ssim:Dlibhydra::ConceptScheme",
            :start=>0,
            :rows=>10
        }

        if response["response"]["numFound"] == 0
          puts 'Creating the Concept Scheme'
          scheme = Dlibhydra::ConceptScheme.new
        else
          puts 'Retrieving the Concept Scheme'
          scheme = Dlibhydra::ConceptScheme.find(response["response"]["docs"].first['id'])
        end
        scheme.preflabel = i
        scheme.save
        config = Rails.root + 'config/dlibhydra.yml'
        text = File.read(config)
        replacement_text = text.gsub(/#{i}:\s\S{2,}\n/, "#{i}: '#{scheme.id}'\n")
        File.open(config, "w") {|file| file.puts replacement_text }

        puts "Concept scheme for #{i} is #{scheme.id}"
      rescue
        puts $!
      end

      # puts 'Processing ' + i
      #
      # arr = CSV.read(path + "assets/lists/#{i}.csv")
      # arr = arr.uniq # remove any duplicates
      #
      # arr.each do |c|
      #   begin
      #     h = Dlibhydra::Concept.new
      #     h.preflabel = c[0].strip
      #     h.altlabel = [c[2].strip] unless c[2].nil?
      #     h.same_as = [c[1].strip] unless c[1].nil?
      #     h.concept_scheme = scheme
      #     h.save
      #     scheme.concepts << h
      #     scheme.save
      #     puts "Term for #{c[0]} created at #{h.id}"
      #   rescue
      #     puts $!
      #   end
      # end
    end
    puts 'Finished!'
  end

  desc "load persons"
  task load_persons: :environment do

    # path = Rails.root + 'lib/'
    # .csv files should exist in the specified path
    # filename will be the name of the concept scheme
    list = ['current_persons']
    list.each do |i|

      begin
        scheme = ''
        solr = RSolr.connect :url => SOLR
        response = solr.get 'select', :params => {
            :q=>"preflabel_tesim:#{i} AND has_model_ssim:Dlibhydra::ConceptScheme",
            :start=>0,
            :rows=>10
        }

        if response["response"]["numFound"] == 0
          puts 'Creating the Concept Scheme'
          scheme = Dlibhydra::ConceptScheme.new
        else
          puts 'Retrieving the Concept Scheme'
          scheme = Dlibhydra::ConceptScheme.find(response["response"]["docs"].first['id'])
        end
        scheme.preflabel = i
        scheme.save
        config = Rails.root + 'config/dlibhydra.yml'
        text = File.read(config)
        replacement_text = text.gsub(/#{i}:\s\S{2,}/, "#{i}: '#{scheme.id}'")
        File.open(config, "w") {|file| file.puts replacement_text }

        puts "Concept scheme for #{i} is #{scheme.id}"
      rescue
        puts $!
      end

      # puts 'Processing ' + i
      #
      # arr = CSV.read(path + "assets/lists/#{i}.csv")
      # arr = arr.uniq # remove any duplicates
      #
      # arr.each do |c|
      #   begin
      #     h = Dlibhydra::Concept.new
      #     h.preflabel = c[0].strip
      #     h.altlabel = [c[2].strip] unless c[2].nil?
      #     h.same_as = [c[1].strip] unless c[1].nil?
      #     h.concept_scheme = scheme
      #     h.save
      #     scheme.concepts << h
      #     scheme.save
      #     puts "Term for #{c[0]} created at #{h.id}"
      #   rescue
      #     puts $!
      #   end
      # end
    end
    puts 'Finished!'
  end

  desc "load departments from csv"
  task load_depts: :environment do

    path = Rails.root + 'lib/'
    # .csv files should exist in the specified path
    # filename will be the name of the concept scheme
    list = ['departments']
    list.each do |i|

      begin
        scheme = ''
        solr = RSolr.connect :url => SOLR
        response = solr.get 'select', :params => {
            :q=>"preflabel_tesim:#{i} AND has_model_ssim:Dlibhydra::ConceptScheme",
            :start=>0,
            :rows=>10
        }

        if response["response"]["numFound"] == 0
          puts 'Creating the Concept Scheme'
          scheme = Dlibhydra::ConceptScheme.new
        else
          puts 'Retrieving the Concept Scheme'
          scheme = Dlibhydra::ConceptScheme.find(response["response"]["docs"].first['id'])
        end
        scheme.preflabel = i
        scheme.save
        config = Rails.root + 'config/dlibhydra.yml'
        text = File.read(config)
        replacement_text = text.gsub(/#{i}:\s\S{2,}/, "#{i}: '#{scheme.id}'")
        File.open(config, "w") {|file| file.puts replacement_text }

        puts "Concept scheme for #{i} is #{scheme.id}"
      rescue
        puts $!
      end

      puts 'Processing ' + i

      arr = CSV.read(path + "assets/lists/#{i}.csv")
      arr = arr.uniq # remove any duplicates

      arr.each do |c|
        begin
          h = Dlibhydra::CurrentOrganisation.new
          h.preflabel = c[0].strip
          h.name = c[0].strip
          h.altlabel = [c[2].strip] unless c[2].nil?
          h.same_as = [c[1].strip] unless c[1].nil?
          h.concept_scheme = scheme
          h.save
          scheme.current_organisations << h
          if i == 'departments'
            scheme.departments << h
          end
          scheme.save
          puts "Term for #{c[0]} created at #{h.id}"
        rescue
          puts $!
        end
      end
    end
    puts 'Finished!'

  end

  desc "load managing organisation"
  task load_man: :environment do

    require 'yaml'
    org = YAML.load_file("#{Rails.root}/config/locales/hyrax.en.yml")['en']['hyrax']['institution_name']
    i = 'current_organisations'

    begin
      scheme = ''
      solr = RSolr.connect :url => SOLR
      response = solr.get 'select', :params => {
          :q => "preflabel_tesim:#{i} AND has_model_ssim:Dlibhydra::ConceptScheme",
          :start => 0,
          :rows => 10
      }

      if response["response"]["numFound"] == 0
        puts 'Creating the Concept Scheme'
        scheme = Dlibhydra::ConceptScheme.new
      else
        puts 'Retrieving the Concept Scheme'
        scheme = Dlibhydra::ConceptScheme.find(response["response"]["docs"].first['id'])
      end
      scheme.preflabel = i
      scheme.save
      config = Rails.root + 'config/dlibhydra.yml'
      text = File.read(config)
      replacement_text = text.gsub(/#{i}:\s\S{2,}/, "#{i}: '#{scheme.id}'")
      File.open(config, "w") { |file| file.puts replacement_text }

      puts "Concept scheme for #{i} is #{scheme.id}"

      response = solr.get 'select', :params => {
          :q => "preflabel_tesim:#{org} AND inScheme_ssim:#{scheme.id}"
      }

      if response["response"]["numFound"] == 0
        puts 'Creating the Organisation'
        institution = Dlibhydra::CurrentOrganisation.new
        institution.preflabel = org
        institution.name = org
        institution.concept_scheme = scheme
        institution.save
      end

    rescue
      puts $!
    end

  end

  desc "load projects"
  task load_projects: :environment do

    # path = Rails.root + 'lib/'
    # .csv files should exist in the specified path
    # filename will be the name of the concept scheme
    list = ['projects']
    list.each do |i|

      begin
        scheme = ''
        solr = RSolr.connect :url => SOLR
        response = solr.get 'select', :params => {
            :q=>"preflabel_tesim:#{i} AND has_model_ssim:Dlibhydra::ConceptScheme",
            :start=>0,
            :rows=>10
        }

        if response["response"]["numFound"] == 0
          puts 'Creating the Concept Scheme'
          scheme = Dlibhydra::ConceptScheme.new
        else
          puts 'Retrieving the Concept Scheme'
          scheme = Dlibhydra::ConceptScheme.find(response["response"]["docs"].first['id'])
        end
        scheme.preflabel = i
        scheme.save
        config = Rails.root + 'config/dlibhydra.yml'
        text = File.read(config)
        replacement_text = text.gsub(/#{i}:\s\S{2,}/, "#{i}: '#{scheme.id}'")
        File.open(config, "w") {|file| file.puts replacement_text }

        puts "Concept scheme for #{i} is #{scheme.id}"
      rescue
        puts $!
      end

      # puts 'Processing ' + i
      #
      # arr = CSV.read(path + "assets/lists/#{i}.csv")
      # arr = arr.uniq # remove any duplicates
      #
      # arr.each do |c|
      #   begin
      #     h = Dlibhydra::Concept.new
      #     h.preflabel = c[0].strip
      #     h.altlabel = [c[2].strip] unless c[2].nil?
      #     h.same_as = [c[1].strip] unless c[1].nil?
      #     h.concept_scheme = scheme
      #     h.save
      #     scheme.concepts << h
      #     scheme.save
      #     puts "Term for #{c[0]} created at #{h.id}"
      #   rescue
      #     puts $!
      #   end
      # end
    end
    puts 'Finished!'
  end

end

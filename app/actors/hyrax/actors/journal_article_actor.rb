# Generated via
#  `rails generate hyrax:work JournalArticle`
module Hyrax
  module Actors
    class JournalArticleActor < Hyrax::Actors::BaseActor

      def create(attributes)
        @cloud_resources = attributes.delete(:cloud_resources.to_s)
        apply_creator(attributes)
        apply_department(attributes)
        apply_creation_data_to_curation_concern
        apply_save_data_to_curation_concern(attributes)
        save && next_actor.create(attributes) && run_callbacks(:after_create_concern)
      end

      def update(attributes)
        apply_creator(attributes)
        apply_department(attributes)
        apply_update_data_to_curation_concern
        apply_save_data_to_curation_concern(attributes)
        save && next_actor.update(attributes) && run_callbacks(:after_update_metadata)
      end

      protected

      # Check each creator_reource_id; create a CurrentPerson for any strings.
      def apply_creator(attributes)
        values = []
        attributes[:creator_resource_ids].each do |c|
          if c.length == 9
            begin
              p = ActiveFedora::Base.find(c)
              values << p
            rescue
              values << create_person(c)
            end
          else
            values << create_person(c)
          end
        end
        attributes[:creator_resource_ids] = []
        attributes[:creator_resource] = values
      end

      # Check each department_resource_id and discard any strings.
      def apply_department(attributes)
        values = []
        attributes[:department_resource_ids].each do |c|
          unless c.length != 9
            begin
              p = ActiveFedora::Base.find(c)
              values << p
            rescue
              # If a string has been entered, discard it
            end
          end
        end
        attributes[:department_resource_ids] = []
        attributes[:department_resource] = values
      end

      # Create a CurrentPerson object
      # return CurrentPerson
      def create_person(preflabel)
        person = Dlibhydra::CurrentPerson.new
        person.preflabel = preflabel
        begin
          person.concept_scheme = Dlibhydra::ConceptScheme.find(DLIBHYDRA['current_persons'])
        rescue
          #log this or deal with this some way
        end
        person
      end

    end
  end
end

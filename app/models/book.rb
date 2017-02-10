# Generated via
#  `rails generate local:work Book`
class Book < ActiveFedora::Base
  include ::Hyrax::WorkBehavior
  include ::Hyrax::BasicMetadata
  # Change this to restrict which works can be added as a child.
  # self.valid_child_concerns = ['JournalArticle']
  validates :title, presence: { message: 'Your work must have a title.' }
  
  self.human_readable_type = 'Book'
end

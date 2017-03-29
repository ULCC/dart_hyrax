# Generated via
#  `rails generate local:work JournalArticle`
class JournalArticle < ::DogBiscuits::JournalArticle # ActiveFedora::Base
  include ::Hyrax::WorkBehavior
  # include ::Hyrax::BasicMetadata
  # Change this to restrict which works can be added as a child.
  # self.valid_child_concerns = []
  validates :title, presence: {message: 'Your work must have a title.'}

  self.human_readable_type = 'Journal Article'

  class JournalArticleIndexer < Hyrax::WorkIndexer
    include DogBiscuits::IndexesJournalArticle
  end

  def self.indexer
    JournalArticleIndexer
  end
end

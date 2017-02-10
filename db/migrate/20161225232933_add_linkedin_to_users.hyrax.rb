# This migration comes from local (originally 20160328222162)
class AddLinkedinToUsers < ActiveRecord::Migration
  def change
    add_column :users, :linkedin_handle, :string
  end
end

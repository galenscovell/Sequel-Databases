
require 'sequel'


DB = Sequel.sqlite('database.db')

unless DB.table_exists? (:posts)
  DB.create_table :posts do
    primary_key :id
    String      :username, :null => false
    String      :content
    String      :title
    String      :tags
    String      :modified
  end
end


class Post < Sequel::Model(:posts)
  # Post model
  plugin :validation_helpers

  def validate
    super
    validates_presence [:username]
    validates_unique([:username, :title])
    validates_unique(:content)
    validates_length_range 1..140, :content
    validates_length_range 1..24, :title
  end
end
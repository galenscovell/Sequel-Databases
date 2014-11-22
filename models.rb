
require 'sequel'


DB = Sequel.sqlite('database.db')

unless DB.table_exists? (:posts)
  DB.create_table :posts do
    primary_key :id
    String      :username, :null => false
    String      :content, :null => false
    String      :title, :null => false
    String      :tags
    String      :modified
  end
end


class Post < Sequel::Model(:posts)
  # Post model
  plugin :validation_helpers

  def validate
    super
    validates_presence [:username, :content, :title], :message => 'Empty field.'
    validates_length_range 1..150, :content
    validates_length_range 1..30, :title
  end
end

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

unless DB.table_exists? (:comments)
  DB.create_table :comments do
    primary_key :number
    Integer     :id
    String      :content
    String      :date_time
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


class Comment < Sequel::Model(:comments)
  # Comment model
  plugin :validation_helpers

  def validate
    super
    validates_length_range 1..200, :content
  end
end


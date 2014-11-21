
require 'sequel'


DB = Sequel.sqlite('database.db')

unless DB.table_exists? (:users)
  DB.create_table :users do
    primary_key :id
    String      :name, :null => false
    String      :email, :null => false
    String      :password, :null => false
    String      :join_date
    String      :updated_at
  end
end

unless DB.table_exists? (:posts)
  DB.create_table :posts do
    primary_key :id
    Text        :content, :null => false
    String      :post_date
    String      :edit_date
    String      :related
  end
end


class User < Sequel::Model(:users)
  # User model
  plugin :validation_helpers

  def validate
    super
    validates_presence [:name, :email, :password]
    validates_unique(:name, :email)
    validates_format /@/, :email
  end
end


class Post < Sequel::Model(:posts)
  # Post model
  plugin :validation_helpers

  def validate
    super
    validates_presence [:content]
    validates_length_range 1..140, :content.size
  end
end
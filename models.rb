
require 'sequel'


DB = Sequel.sqlite('users.db')

unless DB.table_exists? (:users)
  DB.create_table :users do
    primary_key :id
    String      :first_name, :null => false
    String      :last_name, :null => false
    String      :email, :null => false
    Integer     :level
    String      :join_date
  end
end

class User < Sequel::Model(:users)
  # User model
  plugin :validation_helpers

  def validate
    super
    validates_presence [:first_name, :last_name, :email]
    validates_unique([:first_name, :last_name, :email])
    validates_format /@/, :email
  end
end
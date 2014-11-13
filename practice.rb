
require 'sinatra'
require 'sinatra/flash'
require 'sequel'

enable :sessions

DB = Sequel.sqlite('database.db')

unless DB.table_exists? (:players)
  DB.create_table :players do
    primary_key :id
    String      :first_name, :null => false
    String      :last_name, :null => false
    Integer     :level
    String      :join_date
  end
end

class Player < Sequel::Model(:players)
  # Player model
end

# Player List page
get '/' do
  @page_title = "Player List"
  @players = Player.all
  if @players.empty?
    flash[:error] = 'No players found.'
  end
  erb :players
end

# Add new player page
get '/new' do
  @page_title = "Add Player"
  @player = Player.new
  erb :new
end

post '/create' do
  @player = Player.new
  @player.set_fields(params[:player], [:first_name, :last_name])
  @player.level = 1
  @player.join_date = Time.now.strftime('%m/%d/%y at %H:%M')
  if @player.save
    redirect '/'
  else
    redirect '/new'
  end
end



require 'sinatra'
require 'sinatra/flash'
require_relative 'models'

enable :sessions

# Home page
get '/' do
  @page_title = "HOME"
  erb :home
end

# User List page
get '/users' do
  @page_title = "USER LIST"
  @users = User.all
  if @users.empty?
    flash[:error] = 'No users found. Why not add some now?'
  end
  erb :users
end

# Add new user page
get '/new' do
  @page_title = "ADD USER"
  @user = User.new
  erb :new
end

post '/create' do
  @user = User.new
  @user.set_fields(params[:user], [:first_name, :last_name, :email])
  @user.level = 1
  @user.join_date = Time.now.strftime('%m/%d/%y at %H:%M')
  if @user.valid?
    @user.save
    redirect '/users', flash[:notice] = "User added successfully."
  else
    redirect '/new' , flash[:error] = "Unable to add user (already exists or incorrect format)."
  end
end


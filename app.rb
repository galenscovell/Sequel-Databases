
require 'sinatra'
require 'sinatra/flash'
require_relative 'models'

configure do
  enable :sessions
end

helpers do

  def logged_in?
    session[:authorized]
  end

end


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
    flash[:error] = 'No users found. Why not add some?'
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
  @user.set_fields(params[:user], [:name, :email, :password])
  @user.join_date = Time.now.strftime('%m/%d/%y at %H:%M')
  @user.updated_at = Time.now.strftime('%m/%d/%y at %H:%M')
  if @user.valid?
    @user.save
    session[:username] = params[:user]
    redirect '/users', flash[:notice] = "User added successfully."
  else
    redirect '/new' , flash[:error] = "Unable to add user (already exists or incorrect format)."
  end
end


#Login page
get '/login' do
  erb :login
end


# Edit user page
get '/edit/:id' do
  @page_title = "EDIT USER"
  @user = User[params[:id].to_i]
  erb :edit
end

post '/update/:id' do
  @user = User[params[:id].to_i]
  @user.update_fields(params[:user], [:name, :email, :password])
  @user.updated_at = Time.now.strftime('%m/%d/%y at %H:%M')
  if @user.valid?
    @user.save
    redirect '/users', flash[:notice] = "User info updated."
  else
    redirect '/users', flash[:error] = "Unable to update user info."
  end
end


# Delete user
get '/delete/:id' do
  @user = User[params[:id].to_i]
  @user.delete if !@user.nil?
  redirect '/users', flash[:notice] = "User deleted."
end


# Recent posts page
get '/recent' do
  @page_title = "RECENT POSTS"
  @posts = Post.all
  if @posts.empty?
    flash[:error] = "No recent posts."
  end
  erb :recent
end


# 404 Page
not_found do
  @page_title = "404"
  erb :not_found
end

require 'sinatra'
require 'sinatra/flash'
require_relative 'models'


configure do
  enable :sessions
end

# Home page
get '/' do
  @page_title = "HOME"
  erb :home
end


# Viewing posts
get '/recent' do
  @page_title = "ALL POSTS"
  @posts = Post.all
  if @posts.empty?
    flash[:error] = 'No posts found.'
  end
  erb :recent
end

get '/post/:id' do
  @post = Post[params[:id].to_i]
  @page_title = @post.title
  erb :post
end


# Add new user page
get '/new' do
  @page_title = "ADD POST"
  @post = Post.new
  erb :new
end

post '/create' do
  @post = Post.new
  @post.set_fields(params[:post], [:username, :title, :content, :tags])
  @post.modified = Time.now.strftime('%l:%M %p - %e %B %y')
  if @post.valid?
    @post.save
    redirect '/recent', flash[:notice] = "Post published successfully."
  else
    redirect '/new' , flash[:error] = "Unable to publish post (incorrect format?)."
  end
end


# Edit post page
get '/edit/:id' do
  @page_title = "EDIT POST"
  @post = Post[params[:id].to_i]
  erb :edit
end

post '/update/:id' do
  @post = Post[params[:id].to_i]
  @post.update_fields(params[:post], [:username, :title, :content, :tags])
  @post.modified = Time.now.strftime('%l:%M %p - %e %B %y')
  if @post.valid?
    @post.save
    redirect '/recent', flash[:notice] = "Post updated."
  else
    redirect '/recent', flash[:error] = "Unable to update post (incorrect format?)."
  end
end


# Delete post
get '/delete/:id' do
  @post = Post[params[:id].to_i]
  @post.delete if !@post.nil?
  redirect '/recent', flash[:notice] = "Post deleted."
end


# 404 Page
not_found do
  @page_title = "404"
  erb :not_found
end
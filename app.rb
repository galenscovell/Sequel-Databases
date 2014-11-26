
require 'sinatra'
require 'sinatra/flash'
require_relative 'models'


configure do
  enable :sessions
end

helpers do
  include Rack::Utils
  alias_method :h, :escape_html
end



# Home page
get '/' do
  @page_title = Time.now.strftime('%e %B %y')
  erb :home
end



# About page
get '/about' do
  @page_title = "SINATRA MICROBLOGGER"
  erb :about
end

# Search function
get '/search' do
  @page_title = "SEARCH: #{params[:query]}"
  @posts = Post.where(Sequel.ilike(:title, "#{params[:query]}") | Sequel.ilike(:username, "#{params[:query]}"))
  if @posts.empty?
    flash.now[:notice] = "No posts found relating to '#{params[:query]}'. Try a different search term."
  else
    flash.now[:notice] = "Found the following relating to '#{params[:query]}'."
  end
  erb :all
end



# View all posts
get '/all' do
  @page_title = "ALL POSTS"
  @posts = Post.all
  flash.now[:error] = 'No posts found. Why not add one?' if @posts.empty?
  erb :all
end



# View individual post
get '/post/:id' do
  @post = Post[params[:id].to_i]
  @comments = Comment.where(Sequel.like(:id, params[:id]))
  @page_title = @post.title
  erb :post
end

# Add comment
post '/comment/:id' do
  @comment = Comment.new
  @comment.set_fields(params[:comment], [:content, :username])
  @comment.id = params[:id]
  @comment.date_time = Time.now.strftime('%l:%M %p - %e %B %y')
  if @comment.valid?
    @comment.save
    redirect '/post/' + params[:id], flash[:notice] = "Reply added."
  else
    redirect back, flash[:error] = "Unable to add reply (incorrect format)."
  end
end



# Add new post
get '/new' do
  @page_title = "PUBLISH POST"
  @post = Post.new
  erb :new
end

post '/create' do
  @post = Post.new
  @post.set_fields(params[:post], [:username, :title, :content, :tags])
  @post.modified = Time.now.strftime('%l:%M %p - %e %B %y')
  if @post.valid?
    @post.save
    redirect '/all', flash[:notice] = "Post published successfully."
  else
    redirect '/new' , flash[:error] = "Unable to publish post (incorrect format)."
  end
end



# Edit post
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
    redirect '/all', flash[:notice] = "Post updated."
  else
    redirect back, flash[:error] = "Unable to update post (incorrect format)."
  end
end



# Delete post
get '/delete/:id' do
  @post = Post[params[:id].to_i]
  @comments = Comment.where(Sequel.like(:id, params[:id]))
  @comments.delete if !@comments.nil?
  @post.delete if !@post.nil?
  redirect '/all', flash[:notice] = "Post deleted."
end



# 404 Warning
not_found do
  redirect back, flash[:error] = "Whoops, that page doesn't appear to exist."
end
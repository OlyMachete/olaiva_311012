require 'sinatra'
require 'slim'
require 'data_mapper'

=begin
impostazione db  
=end
DataMapper.setup(:default, ENV['DATABASE_URL'] || "sqlite3://#{Dir.pwd}/blog.db")

class Post
	include DataMapper::Resource
	property :id,	Serial
	property :title,	String, :required => true
	property :post,	String, :required => true 
	property :inserted_at,	DateTime
end
DataMapper.finalize

=begin
home page  con slim e visualizzazione ultimi 5 post in ordine di data descrescente
=end
get '/' do
  @posts = Post.all(:order => [ :inserted_at.desc ], :limit => 5)
	if @posts.empty?
	  @error = "There are no post! Create Yours!"
   slim :error
	end
   slim :index2
end

=begin
inserimento nuovo post nel blog  
=end
get '/newpost' do
	slim :newpost
end

=begin
ambaradam per fargli mettere la data di inserimento post  
=end
post '/newpost' do
  blogpost = Post.create params[:post]
  blogpost.inserted_at = blogpost.inserted_at.nil? ? Time.now : nil
  if  blogpost.save
  redirect to('/')
  else
   @error = "Error inserting the post"
   slim :error
 end
end

=begin
visualizzazione dettaglio post  
=end

get '/post/:id' do
 @detail = Post.get(params[:id])
 if @detail
 slim :detail 
 else
   @error = "The post ##{params[:id]} does not exist"
   slim :error
 end
end

=begin
delete di un post  
=end

delete '/post/:id' do
  @destroy = Post.get(params[:id]).destroy
  if @destroy
  redirect to('/')
  else
    @error = "Errore deleting the post ##{params[:id]}"
   slim :error
 end
end

=begin
page not found  
=end

not_found do
  halt 404, 'page not found'
end


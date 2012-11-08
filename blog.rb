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
home page  con slim
=end
get '/' do
	@posts = Post.all
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
  blogpost.save
  redirect to('/')
end

=begin
visualizzazione dettaglio post  
=end

post '/post/:id' do
end

=begin
delete di un post  
=end

delete '/post/:id' do
  Post.get(params[:id]).destroy
  redirect to('/')
end

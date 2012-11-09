require 'sinatra'

get '/hi' do
  erb :hello
end

post '/hello' do
     " '#{params[:message]}'"
end

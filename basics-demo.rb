# This is a Sinatra app. Install Sinatra with 'gem install sinatra'.
# Run it with 'ruby basics-demo.rb'.

require 'rubygems'
require 'bundler/setup'
require 'sinatra'

enable :sessions

helpers do
  def protected!
    unless authorized?
      response['WWW-Authenticate'] = %(Basic realm="Restricted Area")
      throw(:halt, [401, "Not authorized\n"])
    end
  end

  def authorized?
    @auth ||= Rack::Auth::Basic::Request.new(request.env)
    @auth.provided? && @auth.basic? && @auth.credentials && @auth.credentials == ['user', 'password']
  end
end

get '/image' do
  image = (session[:image] || 0)
  session[:image] = (image + 1) % 3
  redirect to("/image/#{image}")
end

get '/image/:id' do
  sleep 3
  cache_control :public, :max_age => 300
  send_file "public/image-#{params[:id]}.jpg"
end

get '/auth-image' do
  protected!
  send_file 'public/image-0.jpg'
end

get '/tarpit' do
  sleep 90
  send_file 'public/image-0.jpg'
end

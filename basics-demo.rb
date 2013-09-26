# This is a Sinatra app. Install Sinatra with 'gem install sinatra'.
# Run it with 'ruby basics-demo.rb'.

require 'rubygems'
require 'bundler/setup'
require 'sinatra'
require 'json'
require 'digest/md5'

set :show_exceptions, false

enable :sessions
set :session_secret, 'essential-networking'

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

unless Array.respond_to? :sample
  require 'securerandom'

  class Array
    # Unlike 1.9.x, this implementation can return duplicates, but it's good
    # enough for demo purposes.
    def sample(n = 1)
      n = [n, self.length].min
      n.times.collect do
        self[SecureRandom.random_number(self.length)]
      end
    end
  end
end

get '/random-words' do
  @words ||= File.readlines('/usr/share/dict/words').map(&:chomp)
  length = (params[:length] || 8).to_i
  @words.sample(length).join(' ')
end

get '/random-words.json' do
  content_type :json
  @words ||= File.readlines('/usr/share/dict/words').map(&:chomp)
  length = (params[:length] || 8).to_i
  @words.sample(length).to_json
end

post '/hash' do
  message = params[:message]
  if message.is_a? Hash
    message = message[:tempfile].read
  end

  Digest::MD5.hexdigest(message)
end

require 'sinatra/base'
require 'webrick'
require 'tilt/erb'
require 'yaml'

class Mombi::Server < Sinatra::Base

  set :views, File.dirname(__FILE__) + '/../../views'
  set :public_folder, File.dirname(__FILE__) + '/../../public'
  set :erb, :trim => '-'

  configure :production, :development do
    enable :logging
    enable :sessions
  end

  get '/' do
    @data = YAML.load_file(settings.config) rescue {}
    erb :index
  end

  get '/blast' do
    settings.relay.blast
    redirect back
  end

  post '/save' do
    settings.relay.save(params)
    redirect back
  end

  not_found do
    status 404
  end

end

require 'sinatra/base'
require 'webrick'
require 'tilt/erb'

class Mombi::Server < Sinatra::Base

  set :views, File.dirname(__FILE__) + '/../../views'
  set :public_folder, File.dirname(__FILE__) + '/../../public'
  set :erb, :trim => '-'

  configure :production, :development do
    enable :logging
    enable :sessions
  end

  before {
    env["rack.logger"] = settings.logger if settings.logger
  }

  get '/' do
    @data = Mombi::config
    erb :index
  end

  get '/blast' do
    settings.relay.blast
    redirect back
  end

  post '/save' do
    save(params)
    redirect back
  end

  not_found do
    status 404
  end

  helpers do
    def save(params={})
      params.each do |key, value|
        key   = key.to_sym
        value = value.to_i if [:interval, :duration, :blast].include? key

        Mombi::set(key, value)
      end

      Mombi::save
    end

  end

end

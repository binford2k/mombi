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
    save(params)
    redirect back
  end

  not_found do
    status 404
  end

  helpers do
    def save(params={})
      File.open(settings.config, File::RDWR|File::CREAT, 0644) {|file|
        file.flock(File::LOCK_EX)
        data = YAML.load(file.read) rescue {}
        file.rewind

        params.each do |key, value|
          key   = key.to_sym
          value = value.to_i if [:interval, :duration].include? key

          data[key] = value
        end

        file.write(data.to_yaml)
        file.flush
        file.truncate(file.pos)
      }

      settings.relay.reload
    end
  end

end

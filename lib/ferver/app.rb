require 'sinatra'
require 'sinatra/base'
require_relative './controller'

module Ferver
  class App < Sinatra::Application
    set :app_file, __FILE__

    configure do
      set :views, './views'
    end

    use Rack::Auth::Basic, 'Ferver' do |username, password|
      if Ferver.configuration.user.nil?
        true
      else
        username == Ferver.configuration.user && password == Ferver.configuration.password
      end
    end

    use Controller
  end
end

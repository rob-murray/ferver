# frozen_string_literal: true
require "sinatra"
require "sinatra/base"
require_relative "./controller"

module Ferver
  class App < Sinatra::Application
    set :app_file, __FILE__

    configure do
      set :views, "./views"
    end

    use Controller
  end
end

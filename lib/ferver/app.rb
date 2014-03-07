require "sinatra"
require "json"
require "sinatra/base"

module Ferver
    class App < Sinatra::Base

        get '/' do
            puts "hello world"
        end

    end
end
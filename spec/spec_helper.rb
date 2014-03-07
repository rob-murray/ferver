require 'rubygems'
require 'spork'
require 'coveralls'

# force the environment to 'test'
ENV['RACK_ENV'] = 'test' 

Coveralls.wear! # this uses SimpleCov under its bonnet

Spork.prefork do
  require File.join(File.dirname(__FILE__), '..', '/lib/', 'ferver', 'file_list')
  require 'ferver'

  require 'rubygems'
  require 'sinatra'
  require 'rspec'
  require 'rack/test'
  require 'webrat'
  
  # test environment stuff
  set :environment, :testf
  set :run, false
  set :raise_errors, true
  set :logging, false

  EMPTY_FILE_LIST = []

  RSpec.configure do |conf|
    conf.include Rack::Test::Methods
    conf.mock_framework = :mocha
  end

  def app
    @app ||= Ferver::App
  end
end

Spork.each_run do
end
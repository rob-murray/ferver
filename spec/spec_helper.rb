# frozen_string_literal: true
require "rubygems"
require "spork"
require "coveralls"
require "simplecov"

# force the environment to 'test'
ENV["RACK_ENV"] = "test"

SimpleCov.start
Coveralls.wear!

Spork.prefork do
  require File.join(File.dirname(__FILE__), "..", "/lib/", "ferver")
  require "ferver"

  require "rubygems"
  require "sinatra"
  require "rspec"
  require "rack/test"
  require "rspec-html-matchers"

  # test environment stuff
  set :environment, :test
  set :run, false
  set :raise_errors, true
  set :logging, false

  EMPTY_FILE_LIST = [].freeze

  RSpec.configure do |config|
    config.include Rack::Test::Methods
    config.include RSpecHtmlMatchers
  end

  def app
    @app ||= Ferver::App
  end
end

Spork.each_run do
end

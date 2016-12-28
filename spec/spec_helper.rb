# frozen_string_literal: true
require "rubygems"
require "coveralls"
require "simplecov"

# Loading more in this block will cause your tests to run faster. However,
# if you change any configuration or code from libraries loaded here, you'll
# need to restart spork for it take effect.
require File.join(File.dirname(__FILE__), "..", "/lib/", "ferver")
require "ferver"
require "rubygems"
require "sinatra"
require "rack/test"
require "rspec-html-matchers"

# force the environment to 'test'
ENV["RACK_ENV"] = "test"

SimpleCov.start
Coveralls.wear!

# See http://rubydoc.info/gems/rspec-core/RSpec/Core/Configuration
RSpec.configure do |config|
  config.expect_with :rspec do |expectations|
    expectations.include_chain_clauses_in_custom_matcher_descriptions = true
  end

  config.mock_with :rspec do |mocks|
    mocks.verify_partial_doubles = true
  end

  config.shared_context_metadata_behavior = :apply_to_host_groups
  config.filter_run_when_matching :focus
  config.disable_monkey_patching!
  config.warnings = true
  config.default_formatter = "doc" if config.files_to_run.one?

  config.order = :random
  Kernel.srand config.seed

  config.include Rack::Test::Methods
  config.include RSpecHtmlMatchers
end

# test environment stuff
set :environment, :test
set :run, false
set :raise_errors, true
set :logging, false

EMPTY_FILE_LIST = [].freeze

def app
  @app ||= Ferver::App
end

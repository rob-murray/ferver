# coding: utf-8
# frozen_string_literal: true
lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "ferver/version"

Gem::Specification.new do |spec|
  spec.name          = "ferver"
  spec.version       = Ferver::VERSION
  spec.authors       = ["Rob Murray"]
  spec.email         = ["robmurray17@gmail.com"]
  spec.summary       = "A simple web app to serve files over HTTP."
  spec.description   = "Ferver is a super, simple ruby gem to serve files over http; useful as a basic file server to quickly share files on your local network."
  spec.homepage      = "https://github.com/rob-murray/ferver"
  spec.license       = "MIT"
  spec.required_ruby_version = ">= 2.0.0"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})

  spec.add_development_dependency "bundler"
  spec.add_development_dependency "nokogiri"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "rspec", "~> 3.0"
  spec.add_development_dependency "rack-test"
  spec.add_development_dependency "rspec-html-matchers"
  spec.add_development_dependency "coveralls"
  spec.add_development_dependency "codeclimate-test-reporter"
  spec.add_development_dependency "byebug"

  spec.add_dependency "sinatra"
end

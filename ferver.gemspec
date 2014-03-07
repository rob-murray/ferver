# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'ferver/version'

Gem::Specification.new do |spec|
  spec.name          = "ferver"
  spec.version       = Ferver::VERSION
  spec.authors       = ["Rob Murray"]
  spec.email         = ["robmurray17@gmail.com"]
  spec.summary       = %q{A simple Ruby app serving files over HTTP.}
  spec.description   = %q{Write me}
  spec.homepage      = "https://github.com/rob-murray/ferver"
  spec.license       = "MIT"
  spec.post_install_message =<<eos
********************************************************************************

  Thanks for installing Ferver.
  To serve files from the current directory, just run `ferver`.
  Or pass in the path to the directory to serve from `ferver /path/to/files`.

********************************************************************************
eos
  
  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }


  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.5"
  spec.add_development_dependency "rake", "~> 0"
  spec.add_development_dependency "rspec", "~> 2.14.1"
  spec.add_development_dependency "rack-test", "~> 0.6.2"
  spec.add_development_dependency "mocha", "~> 1.0.0"
  spec.add_development_dependency "spork", "~> 0.9.2"
  spec.add_development_dependency "webrat", "~> 0.7.3"
  spec.add_development_dependency "coveralls", "~> 0.7.0"

  spec.add_dependency "sinatra", "~> 1.4.4"
end

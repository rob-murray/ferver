require "ferver/version"

module Ferver
  autoload :App, 'ferver/app'

  class DirectoryNotFoundError < StandardError; end
end

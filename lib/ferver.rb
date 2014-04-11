require_relative "ferver/app"
require_relative "ferver/file_id_request"
require_relative "ferver/file_list"
require_relative "ferver/version"

module Ferver
  autoload :App, 'ferver/app'

  class DirectoryNotFoundError < StandardError; end
end

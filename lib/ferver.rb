require_relative 'ferver/app'
require_relative 'ferver/directory_not_found_error'
require_relative 'ferver/file_id_request'
require_relative 'ferver/file_list'
require_relative 'ferver/version'

module Ferver
  autoload :App, 'ferver/app'

  # By default, serve files from current location when the gem
  #   binary is called.
  DEFAULT_FILE_SERVER_DIR_PATH = './'
end

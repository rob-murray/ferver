# frozen_string_literal: true
require_relative "ferver/app"
require_relative "ferver/controller"
require_relative "ferver/configuration"
require_relative "ferver/directory_not_found_error"
require_relative "ferver/file_id_request"
require_relative "ferver/file_list"
require_relative "ferver/found_file"
require_relative "ferver/version"

module Ferver
  # By default, serve files from current location when the gem is called.
  DEFAULT_FILE_SERVER_DIR_PATH = "./".freeze

  class << self
    attr_accessor :configuration

    def configuration
      @configuration ||= Configuration.new
    end

    def reset
      @configuration = Configuration.new
    end

    def configure
      yield(configuration)
    end
  end
end

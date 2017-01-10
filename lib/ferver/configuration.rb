# frozen_string_literal: true
module Ferver
  class Configuration
    # By default, serve files from current location when the gem is called.
    DEFAULT_FILE_SERVER_DIR_PATH = "./".freeze

    # Return the absolute path to the directory Ferver is serving files from.
    attr_accessor :directory_path

    # Default to not serving hidden files.
    attr_accessor :serve_hidden

    # For testing
    attr_writer :directory

    alias serve_hidden? serve_hidden

    def initialize(directory_path = DEFAULT_FILE_SERVER_DIR_PATH, serve_hidden = false)
      @directory_path = directory_path
      @serve_hidden   = serve_hidden
    end

    def directory
      @directory ||= FerverDirectory.new(self)
    end
  end
end

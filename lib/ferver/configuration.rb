module Ferver
  class Configuration
    attr_accessor :directory_path, :serve_hidden

    # Return the absolute path to the directory Ferver is serving files from.
    #
    def directory_path
      @directory_path || Ferver::DEFAULT_FILE_SERVER_DIR_PATH
    end

    # Default to not serving hidden files
    #
    def serve_hidden
      @serve_hidden || false
    end
    alias_method :serve_hidden?, :serve_hidden
  end
end

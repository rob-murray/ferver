module Ferver
  class Configuration
    attr_accessor :directory_path, :serve_invisible

    # Return the absolute path to the directory Ferver is serving files from.
    #
    def directory_path
      @directory_path || Ferver::DEFAULT_FILE_SERVER_DIR_PATH
    end

    # Default to not serving invisible files
    #
    def serve_invisible
      @serve_invisible || false
    end
  end
end

module Ferver
  class Configuration
    attr_accessor :directory_path, :user, :password

    # Return the absolute path to the directory Ferver is serving files from.
    #
    def directory_path
      @directory_path || Ferver::DEFAULT_FILE_SERVER_DIR_PATH
    end
  end
end

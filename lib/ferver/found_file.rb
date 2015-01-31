module Ferver
  class FoundFile
    def initialize(directory, file_name)
      @directory, @file_name = directory, file_name
      @path_for_file = File.join(@directory, @file_name)
    end

    # Return an absolute path to the file
    #
    def path_for_file
      @path_for_file
    end

    def name
      @file_name
    end

    def valid?
      File.file?(@path_for_file)
    end
  end
end

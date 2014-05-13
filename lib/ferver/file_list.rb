# A representation of Ferver's file list
#
module Ferver
  class FileList
    # List of files
    attr_reader :files

    # create a new instance with a path
    #
    def initialize(path)
      fail ArgumentError, 'No path is specified' if path.empty?
      fail DirectoryNotFoundError unless Dir.exist?(path)

      @file_path = File.expand_path(path)
      find_files
    end

    # Return an absolute path to a `file_name` in the `directory`
    #
    def self.path_for_file(directory, file_name)
      File.join(directory, file_name)
    end

    # Is the file id a valid id for Ferver to serve
    #
    def file_id_is_valid?(file_id)
      file_id < @files.size
    end

    # Filename by its index
    #
    def file_by_id(id)
      @files.fetch(id)
    end

    # Number of files in list
    #
    def file_count
      @files.size
    end

    private

      # Iterate through files in specified dir for files
      #
    def find_files
      @files = []

      Dir.foreach(@file_path) do |file|
        next if file == '.' || file == '..'

        file_path = FileList.path_for_file(@file_path, file)
        @files << file if File.file?(file_path)
      end
    end
  end
end

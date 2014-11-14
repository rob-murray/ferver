require 'forwardable'

# A representation of Ferver's file list
#
module Ferver
  class FileList
    extend Forwardable
    include Enumerable

    def_delegators :@files, :size, :each

    # Create a new instance with a path
    #
    def initialize(path)
      fail ArgumentError, 'No path is specified' if path.empty?
      fail DirectoryNotFoundError unless Dir.exist?(path)

      @files = []
      @configured_file_path = File.expand_path(path)
      find_files
    end

    # Return an absolute path to a `file_name` in the `directory`
    #
    def self.path_for_file(directory, file_name)
      File.join(directory, file_name)
    end

    # Is the file id a valid id for Ferver to serve
    #
    def file_id_valid?(file_id)
      file_id < files.size
    end

    # Filename by its index
    #
    def file_by_id(id)
      files.fetch(id)
    end

    def all
      files
    end

    private

    attr_reader :configured_file_path, :files

    # Iterate through files in specified dir for files
    #
    def find_files
      @files = []

      Dir.foreach(configured_file_path) do |file|
        next if file == '.' || file == '..'

        file_path = FileList.path_for_file(configured_file_path, file)
        @files << file if File.file?(file_path)
      end
    end
  end
end

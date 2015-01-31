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

      Dir.foreach(configured_file_path) do |found_file|
        next if found_file == '.' || found_file == '..'

        file = FoundFile.new(configured_file_path, found_file)
        @files << file if file.valid?
      end
    end
  end
end

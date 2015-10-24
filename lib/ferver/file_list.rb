require 'forwardable'

# A representation of Ferver's file list
#
module Ferver
  class FileList
    include Enumerable

    # Create a new instance with a path
    #
    def initialize(path)
      fail ArgumentError, 'No path is specified' if path.empty?
      fail DirectoryNotFoundError unless Dir.exist?(path)

      @configured_file_path = File.expand_path(path)
      @files = find_files.sort_by! { |f| f.name.downcase }
    end

    def each(&block)
      files.each(&block)
    end

    def size
      files.size
    end

    # Filename by its index
    # An id out of range with raise IndexError
    #
    def file_by_id(id)
      files.fetch(id)
    end

    private

    attr_reader :configured_file_path, :files

    # Iterate through files in specified dir for files
    #
    def find_files
      [].tap do |results|
        Dir.foreach(configured_file_path) do |file_name|
          next if file_name == '.' || file_name == '..'
          next if file_name =~ /^\./ && !Ferver.configuration.serve_hidden?

          found_file = FoundFile.new(configured_file_path, file_name)
          results << found_file if found_file.valid?
        end
      end
    end
  end
end

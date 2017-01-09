# frozen_string_literal: true
module Ferver
  # A wrapper around the directory specified by config
  class FerverDirectory
    def initialize(configuration)
      path = configuration.directory_path
      raise ArgumentError, "No path is specified" if path.empty?
      raise DirectoryNotFoundError unless Dir.exist?(path)

      @configuration = configuration
    end

    def path
      configuration.directory_path
    end

    def full_path
      @_full_path ||= File.expand_path(path)
    end

    def found_files
      find_files
    end

    private

    attr_reader :configuration

    # Iterate through files in specified dir for files
    #
    def find_files
      [].tap do |results|
        Dir.foreach(full_path) do |file_name|
          next if file_name == "." || file_name == ".."
          next if file_name =~ /^\./ && !configuration.serve_hidden?

          found_file = FoundFile.new(full_path, file_name)
          results << found_file if found_file.valid?
        end
      end
    end
  end
end

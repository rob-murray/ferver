# frozen_string_literal: true
module Ferver
  # A representation of Ferver's file list
  class FileList
    include Enumerable

    # Create a new instance with given directory
    #
    def initialize(files)
      @files = files.sort_by { |f| f.name.downcase }
    end

    def each(&block)
      @files.each(&block)
    end

    def size
      @files.size
    end

    # Fetch a file by its index
    # An id out of range with raise FileNotFoundError
    #
    def file_by_id(id)
      @files.at(id) || raise(FileNotFoundError, "File id=#{id} not found")
    end
  end
end

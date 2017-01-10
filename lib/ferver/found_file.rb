# frozen_string_literal: true
module Ferver
  class FoundFile
    attr_reader :file_name, :path_to_file

    alias name file_name

    def initialize(directory, file_name)
      @file_name = file_name
      @path_to_file = File.join(directory, file_name)
    end

    def valid?
      File.file?(path_to_file) && !File.zero?(path_to_file)
    end
  end
end

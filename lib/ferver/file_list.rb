# A representation of Ferver's file list
#
module Ferver
    class FileList

      # List of files
      attr_reader :file_list

      # create a new instance with a path
      #
      def initialize(path)

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

        file_id < @file_list.size

      end

      # Filename by its index
      #
      def file_by_id(id)

        @file_list[id]

      end

      # Number of files in list 
      #
      def file_count

        @file_list.size

      end

      private

        # Iterate through files in specified dir for files
        #
        def find_files

          @file_list = []

          Dir.foreach(@file_path) do |file|

            next if file == '.' or file == '..'

            file_path = FileList.path_for_file(@file_path, file)

            @file_list << file if File.file?(file_path)

          end

        end

    end
end
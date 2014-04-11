require "sinatra"
require "json"
require "sinatra/base"

module Ferver
  class App < Sinatra::Base

    set :app_file, __FILE__

    # redirect to file list
    # /
    get "/" do
      redirect to("/files")
    end

    # list files; repond as html or json
    # /files
    get "/files" do
      file_list = @ferver_list.files

      if request.preferred_type.to_s == "application/json"
        content_type :json

        file_list.to_json
      else
        @file_count = @ferver_list.file_count
        @ferver_path = File.expand_path(get_current_ferver_path)
        @file_list = file_list

        erb :index
      end
      
    end

    # download file
    # /files/:id
    get "/files/:id" do
      id_request = Ferver::FileIdRequest.new(params[:id])

      halt(400, "Bad request") unless id_request.valid?
      
      if @ferver_list.file_id_is_valid?(id_request.value)
        file_name = @ferver_list.file_by_id(id_request.value)
        file = FileList.path_for_file(get_current_ferver_path, file_name)

        send_file(file, :disposition => 'attachment', :filename => File.basename(file))
      else
        status 404
      end
    end


    # Find all files in `Ferver` directory. 
    # !Called before each request
    #
    before do
      begin
        @ferver_list = FileList.new(get_current_ferver_path)
      rescue DirectoryNotFoundError
        halt(500, "Ferver: Directory '#{get_current_ferver_path}' not found.")
      end
    end

    private

      # Return the absolute path to the directory Ferver is serving files from.
      # This can be specified in Sinatra configuration:
      #   e.g. `Ferver::App.set :ferver_path, ferver_path` or the default if nil
      #
      def get_current_ferver_path
        @current_ferver_path ||= begin
          path = nil

          if settings.respond_to?(:ferver_path) && settings.ferver_path
            path = settings.ferver_path
          else
            path = Ferver::DEFAULT_FILE_SERVER_DIR_PATH
          end
        end
      end

  end
end
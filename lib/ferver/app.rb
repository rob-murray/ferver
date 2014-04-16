require "sinatra"
require "json"
require "sinatra/base"
require_relative "./directory_not_found_error"

module Ferver
  class App < Sinatra::Base

    set :app_file, __FILE__

    before do
      @ferver_list = FileList.new(get_current_ferver_path)
    end

    error Ferver::DirectoryNotFoundError do
      halt 500, "Ferver: Directory '#{@current_ferver_path}' not found."
    end

    # redirect to file list
    get "/" do
      redirect to("/files")
    end

    # list files
    get "/files" do
      if request.preferred_type.to_s == "application/json"
        content_type :json

        @ferver_list.files.to_json
      else
        @file_count = @ferver_list.file_count
        @ferver_path = File.expand_path(get_current_ferver_path)
        @file_list = @ferver_list.files

        erb :index
      end
    end

    # download file
    get "/files/:id" do
      halt(400, "Bad request") unless valid_file_request?
      
      if @ferver_list.file_id_is_valid?(@file_id_request.value)
        file_name = @ferver_list.file_by_id(@file_id_request.value)
        file = FileList.path_for_file(get_current_ferver_path, file_name)

        send_file(file, :disposition => 'attachment', :filename => File.basename(file))
      else
        status 404
      end
    end

    private

    def file_id_request
      @file_id_request ||= FileIdRequest.new(params[:id])
    end

    def valid_file_request?
      file_id_request.valid?
    end

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
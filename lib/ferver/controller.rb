# frozen_string_literal: true
require "sinatra"
require "sinatra/base"
require "json"

module Ferver
  class Controller < Sinatra::Base
    before do
      @ferver_list = FileList.new(Ferver.configuration.directory.found_files)
    end

    before "/files/:id" do
      begin
        @file = find_file! Integer(params[:id])
      rescue ArgumentError
        halt 400, "Bad request"
      end
    end

    error Ferver::DirectoryNotFoundError do
      halt 500, "Ferver: Directory '#{current_ferver_path}' not found."
    end

    # redirect to file list
    get "/" do
      redirect to("/files")
    end

    # list files
    get "/files" do
      if json_request?
        content_type :json

        ferver_list.map(&:name).to_json
      else
        erb :index, locals: { file_list: ferver_list,
                              ferver_path: current_full_path,
                              file_count: ferver_list.size }
      end
    end

    # download file
    get "/files/:id" do
      send_file @file.path_to_file, disposition: String.new("attachment"), filename: @file.name
    end

    private

    attr_reader :ferver_list

    def find_file!(file_id)
      ferver_list.file_by_id(file_id)
    rescue Ferver::FileNotFoundError => error
      halt 404, error.message
    end

    def json_request?
      request.preferred_type.to_s == "application/json"
    end

    def current_ferver_path
      Ferver.configuration.directory.path
    end

    def current_full_path
      Ferver.configuration.directory.full_path
    end
  end
end

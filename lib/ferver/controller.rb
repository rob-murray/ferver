require 'sinatra'
require 'sinatra/base'
require 'json'
require_relative './directory_not_found_error'
require_relative './configuration'

module Ferver
  class Controller < Sinatra::Base
    before do
      @ferver_list = FileList.new(current_ferver_path)
    end

    before '/files/:id' do
      halt(400, 'Bad request') unless valid_file_request?

      find_file!
    end

    error Ferver::DirectoryNotFoundError do
      halt 500, "Ferver: Directory '#{current_ferver_path}' not found."
    end

    helpers do
      def protected!
        unless authorized?
          response['WWW-Authenticate'] = %(Basic realm="Restricted Area")
          throw(:halt, [401, "Not authorized\n"])
        end
      end

      def authorized?
        @auth ||=  Rack::Auth::Basic::Request.new(request.env)
        return true if Ferver.configuration.user.nil?
        @auth.provided? && @auth.basic? && @auth.credentials && @auth.credentials == [Ferver.configuration.user, Ferver.configuration.password]
      end
    end

    # redirect to file list
    get '/' do
      protected!
      redirect to('/files')
    end

    # list files
    get '/files' do
      protected!
      if request.preferred_type.to_s == 'application/json'
        content_type :json

        ferver_list.map{ |f| f.name }.to_json
      else
        erb :index, locals: { file_list: ferver_list,
                              ferver_path: current_full_path,
                              file_count: ferver_list.size }
      end
    end

    # download file
    get '/files/:id' do
      protected!
      send_file(
        @file.path_to_file, disposition: 'attachment', filename: @file.name
      )
    end

    private

    attr_reader :ferver_list

    def file_id_request
      @file_id_request ||= FileIdRequest.new(params[:id])
    end

    def valid_file_request?
      file_id_request.valid?
    end

    def find_file!
      @file = ferver_list.file_by_id(file_id_request.value)
    rescue IndexError
      halt 404, 'File requested not found.'
    end

    def current_ferver_path
      Ferver.configuration.directory_path
    end

    def current_full_path
      File.expand_path(current_ferver_path)
    end

    def authorised?(user, password)
      return true if Fever.configuration.user.nil?
      return true if user == Fever.configuration.user && password == Ferver.configuration.password
      return false
    end
  end
end

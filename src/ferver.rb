#!/usr/bin/env ruby
# encoding: UTF-8

###
# ferver - A simple Ruby app serving files over HTTP
# (c) 2014 Robert Murray
# @see https://github.com/rob-murray/ferver
# http-file-server may be freely distributed under the MIT license
###
require "sinatra"
require "json"
require "sinatra/base"


class Ferver < Sinatra::Base

  # Config
  set :inline_templates, true
  set :app_file, __FILE__

  # By default, serve files from current location
  DEFAULT_FILE_SERVER_DIR_PATH = './'

  # redirect to file list
  # /
  get '/' do

    redirect to('/files')

  end


  # list files; repond as html or json
  # /files
  get '/files' do

    if request.preferred_type.to_s == "application/json"

      content_type :json
      @ferver_list.get_file_list.to_json

    else

      @file_count = @ferver_list.file_count
      @ferver_path = File.expand_path(get_current_ferver_path)
      @file_list = @ferver_list.get_file_list

      erb :file_list_view

    end
    
  end


  # download file
  # /files/:id
  get '/files/:id' do
    
    id = params[:id].to_i
    
    if @ferver_list.file_id_is_valid?(id)

      file_name = @ferver_list.file_by_id(id)

      file = FerverList.path_for_file(get_current_ferver_path, file_name)

      send_file(file, :disposition => 'attachment', :filename => File.basename(file))

    else

      status 404

    end
    
  end


  # Find all files in `Ferver` directory. 
  # !Called before each request
  #
  before do
    
    @ferver_list = FerverList.new(get_current_ferver_path)

  end

  private

    # Return the absolute path to the directory Ferver is serving files from.
    # This can be specified in Sinatra configuration; 
    #   i.e. `Ferver.set :ferver_path, ferver_path` or the default if nil
    #
    def get_current_ferver_path

      path = nil

      if settings.respond_to?(:ferver_path) and settings.ferver_path

        path = settings.ferver_path

      else

        path = DEFAULT_FILE_SERVER_DIR_PATH

      end

    end

end

# A representation of Ferver's file list
#
class FerverList

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

  # List of filenames
  #
  def get_file_list

    @file_list

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

        file_path = FerverList.path_for_file(@file_path, file)

        @file_list.push(file) if File.file?(file_path)

      end

    end

end


__END__
 
@@file_list_view
<!DOCTYPE html>
<html lang="en">
  <head>
    <meta charset="utf-8">
    <title>Ferver File List</title>
  </head>
  <body>
    <h3>Files served:</h3>
    <ul>
      <% @file_list.each_with_index do |file_name, index| %>

        <li><a href="/files/<%= index %>"><%= file_name %></a></li>

      <% end %>

    </ul>

    <p><%= @file_count %> files served from: <%= @ferver_path %></p>

    <hr>

    <p>Served by: <a href="https://github.com/rob-murray/ferver" title="Ferver: A simple Ruby app serving files over HTTP">Ferver</a></p>

  </body>
</html>

<html>
<body>



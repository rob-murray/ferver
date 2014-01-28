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

  # By default, serve files from current location
  DEFAULT_FILE_SERVER_DIR_PATH = './'

  # redirect to file list
  # /
  get '/' do

    redirect to('/files.html')

  end


  # list files
  # /files.html
  get '/files.html' do
    
    content = "<html><body><h3>Files served:</h3><p><ul>"

    @file_list.each_with_index do |file, index|

      content += "<li><a href=""/files/#{index}"">#{file}</a></li>"

    end

    content += "</ul></p><p>#{@file_list.size} files served from: #{get_current_ferver_path}</p></body></html>"
    
  end


  # list files
  # /files.json
  get '/files.json' do
    
    content_type :json
    
    @file_list.to_json
    
  end


  # download file
  # /files/:id
  get '/files/:id' do
    
    id = params[:id].to_i
    
    if id < @file_list.size

      file = get_path_for_file(get_current_ferver_path, @file_list[id])

      send_file(file, :disposition => 'attachment', :filename => File.basename(file))

    else

      status 404

    end
    
  end


  # before each block
  before do
    
    @file_list = []

    current_directory = get_current_ferver_path
    
    Dir.foreach(current_directory) do |file|

      next if file == '.' or file == '..'

      file_path = get_path_for_file(current_directory, file)

      @file_list.push(file) if File.file?(file_path)

    end

  end

  private

  def get_path_for_file(directory, file_name)

    File.join(directory, file_name)

  end


  def get_current_ferver_path

    path = nil

    if settings.respond_to?(:ferver_path) and settings.ferver_path

      path = settings.ferver_path

    else

      path = DEFAULT_FILE_SERVER_DIR_PATH

    end

    File.expand_path(path)

  end


end

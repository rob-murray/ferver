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

  # The full path to the directory to be served
  DEFAULT_FILE_SERVER_DIR_PATH = '/tmp'

  @file_list = []

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

    content += "</ul></p></body></html>"
    
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

      file = "#{get_current_url}/#{@file_list[id]}" # todo: urgghh -> move this

      send_file(file, :disposition => 'attachment', :filename => File.basename(file))

    else

      status 404

    end
    
  end


  # before each block
  before do
    
    @file_list = []

    current_directory = get_current_url
    
    #simple loop to add all files in Dir to array,excluding . and ..
    Dir.foreach(current_directory) do |file|

      next if file == '.' or file == '..'

      @file_list.push(file) if File.file?(file)

    end

  end

  private

  def get_current_url
    DEFAULT_FILE_SERVER_DIR_PATH
  end


end

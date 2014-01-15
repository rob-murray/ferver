#!/usr/bin/env ruby
# encoding: UTF-8

###
# http-file-server - A simple Ruby app serving files over HTTP
# (c) 2014 Robert Murray
# @see https://github.com/rob-murray/ruby-http-file-server
# http-file-server may be freely distributed under the MIT license
###
require "sinatra"
require "json"
require "sinatra/base"


class HttpFileServer < Sinatra::Base

  # Config

  # The full path to the directory to be served 
  FILE_SERVER_DIR_PATH = '/tmp'

  @file_list = []


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

      file = "#{FILE_SERVER_DIR_PATH}/#{@file_list[id]}"

      send_file(file, :disposition => 'attachment', :filename => File.basename(file))

    else

      status 404

    end
    
  end


  # before each block
  before do
    
    @file_list = [] #redef array ie clear and read list again
    
    #simple loop to add all files in Dir to array,excluding . and ..
    Dir.foreach(FILE_SERVER_DIR_PATH) do |file|

      next if file == '.' or file == '..'

      @file_list.push(file)

    end

  end  


end

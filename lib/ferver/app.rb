require "sinatra"
require "json"
require "sinatra/base"
require "ferver/file_list"

module Ferver
  class App < Sinatra::Base

    # Config
    set :inline_templates, true
    set :app_file, __FILE__

    # By default, serve files from current location when the gem 
    #   binary is called.
    DEFAULT_FILE_SERVER_DIR_PATH = './'

    # redirect to file list
    # /
    get '/' do

      redirect to('/files')

    end


    # list files; repond as html or json
    # /files
    get '/files' do

      file_list = @ferver_list.files

      if request.preferred_type.to_s == "application/json"

        content_type :json
        file_list.to_json

      else

        @file_count = @ferver_list.file_count
        @ferver_path = File.expand_path(get_current_ferver_path)
        @file_list = file_list

        erb :file_list_view

      end
      
    end


    # download file
    # /files/:id
    get '/files/:id' do

      id = Integer(params[:id]) rescue halt(400)
      
      if @ferver_list.file_id_is_valid?(id)

        file_name = @ferver_list.file_by_id(id)

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
      
      @ferver_list = FileList.new(get_current_ferver_path)

    end

    private

      # Return the absolute path to the directory Ferver is serving files from.
      # This can be specified in Sinatra configuration; 
      #   i.e. `Ferver::App.set :ferver_path, ferver_path` or the default if nil
      #
      def get_current_ferver_path

        @current_ferver_path ||= begin
          path = nil

          if settings.respond_to?(:ferver_path) and settings.ferver_path
            path = settings.ferver_path
          else
            path = DEFAULT_FILE_SERVER_DIR_PATH
          end
        end        

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
require 'spec_helper'

describe 'ferver' do
    include Webrat::Matchers # allow cool html matching

    DEFAULT_FERVER_DIR = '/tmp'

    context 'given a request to the server root' do

        before(:each) do
            get '/'
        end


        it 'should return redirect' do

            expect(last_response).to be_redirect

        end

        it 'should redirect to file list' do

            follow_redirect!

            expect(last_response).to be_ok
            expect(last_request.url).to eq('http://example.org/files.html') 
            # this 'http://example.org/' appears to be what Rack test inserts? do I care - im only interested in the /files.html

        end

    end


    context 'test serving directory' do # todo: reword this


        it 'will use default directory when none specified' do

            Dir.expects(:foreach).with(DEFAULT_FERVER_DIR).returns([])
            get '/files.html'

        end

    end


    context 'given an empty list of files' do

        before(:each) do
            Dir.stubs(:foreach).returns([])
        end

        it 'will return empty list as html' do

            get '/files.html'
            expect(last_response).to be_ok
            
            expect(last_response.body).not_to have_selector("a")

        end

        it 'will return empty list as json' do

            get '/files.json'
            expect(last_response).to be_ok

            list = JSON.parse last_response.body

            expect(list).to eq([])

        end

    end


    context 'given a list of files' do

        file_list = ["file1", "file2"]

        before(:each) do
            Dir.stubs(:foreach).multiple_yields("file1", "file2")
        end

        it 'will return a list as html' do

            get '/files.html'
            expect(last_response).to be_ok

            expect(last_response.body).to have_selector("li", :count => 2)

        end

        it 'will return a list as json' do

            get '/files.json'
            expect(last_response).to be_ok

            list = JSON.parse last_response.body
            expect(list.count).to eq(2)
            expect(list).to match_array(file_list)

        end

        it 'will return display filenames in html' do

            get '/files.html'

            expect(last_response.body).to have_selector("li") do |node|

                expect(node.first).to have_selector("a", :content => file_list.first)
                expect(node.last).to have_selector("a", :content => file_list.last)

            end

        end

        context 'given a list of files with current working dir and parent' do

            valid_file_list = ["file1"]

            before(:each) do
                Dir.stubs(:foreach).multiple_yields(".", "..", "file1")
            end

            it 'will return only files as html' do

                get '/files.html'
                expect(last_response).to be_ok

                expect(last_response.body).to have_selector("li", :count => 1)
                expect(last_response.body).to have_selector("a", :content => valid_file_list.first)

            end

            it 'will return only files as json' do

                get '/files.json'
                expect(last_response).to be_ok

                list = JSON.parse last_response.body
                expect(list.count).to eq(1)
                expect(list).to match_array(valid_file_list)

            end

        end

        context 'downloading a file' do

            it 'will return not_found for file id out of range' do # urrrghhh; improve this

                get '/files/3'

                expect(last_response).to be_not_found

            end

            it 'will return not_found for invalid file request' do 

                get '/files/foo'

                expect(last_response).to be_not_found

            end

            xit 'will return the file as requested' do

                # havent worked out how to test this yet.

                get '/files/0'

                expect(last_response).to be_ok
                expect(last_response.headers['Content-Type']).to eq("application/octet-stream")

            end

        end

    end

end
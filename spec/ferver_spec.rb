require 'spec_helper'

describe 'ferver' do
    include Webrat::Matchers # allow cool html matching


    context "given a request to the server root" do

        before(:each) do
            get '/'
        end

        it "should return redirect" do
            expect(last_response).to be_redirect
        end

        it "should redirect to file list" do
            follow_redirect!

            expect(last_response).to be_ok
            expect(last_request.url).to match(/files/)
        end

    end

    describe "choosing directory to serve files from" do

        before {
            @file_list = mock()
            @file_list.stubs(:files).returns(EMPTY_FILE_LIST)
            @file_list.stubs(:file_count).returns(0)
        }

        context "when no directory is specified" do

            it "will use default directory" do

                Ferver::FileList.expects(:new).with('./').returns(@file_list)

                get '/files'
            end

        end

        context "when the directory passed via configuration" do

            before { Ferver::App.set :ferver_path, '/foo' }

            it "will use directory specified" do
                Ferver::FileList.expects(:new).with('/foo').returns(@file_list)

                get '/files'
            end

        end

    end

    context 'given an empty list of files' do

        before {
            file_list = mock()
            file_list.stubs(:files).returns(EMPTY_FILE_LIST)
            file_list.stubs(:file_count).returns(0)
            Ferver::FileList.stubs(:new).returns(file_list)
        }

        context "when no content-type is requested" do

            before { get '/files' }

            it "should return valid response" do
                expect(last_response).to be_ok
                #todo test html
            end

            it "should contain no file list in response content" do
                expect(last_response.body).to have_selector("li", :count => 0)
                expect(last_response.body).to contain(/0 files/)
            end

        end

        context "when json content-type is requested" do

            before {
                get '/files', {}, {"HTTP_ACCEPT" => "application/json" }
            }

            it "should return valid response" do
                expect(last_response).to be_ok
                expect(last_response.content_type).to include('application/json')
            end

            it "should contain no file list in response content" do
                list = JSON.parse last_response.body
                expect(list).to eq(EMPTY_FILE_LIST)
            end

        end

    end

    context 'given a list of files' do

        before {
            file_list = mock()
            file_list.stubs(:files).returns(["file1", "file2"])
            file_list.stubs(:file_count).returns(2)
            Ferver::FileList.stubs(:new).returns(file_list)
        }

        context "when no content-type is requested" do

            before { get '/files' }

            it "should return valid response" do
                expect(last_response).to be_ok
                #todo test html
            end

            it "should contain no file list in response content" do
                expect(last_response.body).to have_selector("li", :count => 2)
                expect(last_response.body).to contain(/2 files/)
            end

            it "should list filenames" do
                expect(last_response.body).to have_selector("li") do |node|

                    expect(node.first).to have_selector("a", :content => "file1")
                    expect(node.last).to have_selector("a", :content => "file2")

                end
            end

        end

        context "when json content-type is requested" do

            before {
                get '/files', {}, {"HTTP_ACCEPT" => "application/json" }
            }

            it "should return valid response" do
                expect(last_response).to be_ok
                expect(last_response.content_type).to include('application/json')
            end

            it "should contain no file list in response content" do
                list = JSON.parse last_response.body
                expect(list.count).to eq(2)
                expect(list).to match_array(["file1", "file2"])
            end

        end

    end


    describe "downloading a file" do

        before {
            @file_list = mock()
            @file_list.stubs(:files).returns(["file1", "file2"])
            @file_list.stubs(:file_count).returns(2)
            Ferver::FileList.stubs(:new).returns(@file_list)
        }

        context "when requesting a file out of range" do

            before {
                @file_list.expects(:file_id_is_valid?).with(3).returns(false)
                get '/files/3'
            }

            it "should return not_found" do
                expect(last_response).to be_not_found
            end

        end

        context "when requesting invalid file id" do

            before {
                @file_list.expects(:file_id_is_valid?).never
                get '/files/foo'
            }

            it "should return not_found" do
                expect(last_response).to be_bad_request
            end

        end

        context "when requesting a valid file id" do

            before { get '/files/0' }

            xit "should return ok response" do
                expect(last_response).to be_ok
            end

            xit "should return octet-stream content-type" do
                expect(last_response.headers['Content-Type']).to eq("application/octet-stream")
            end

        end

    end

end
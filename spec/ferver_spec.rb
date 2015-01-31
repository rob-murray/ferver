require 'spec_helper'

describe 'ferver' do
  let(:file_list) { double('Ferver::FileList') }

  context 'given a request to the server root' do
    before do
      get '/'
    end

    it 'should return redirect' do
      expect(last_response).to be_redirect
    end

    it 'should redirect to file list' do
      follow_redirect!

      expect(last_response).to be_ok
      expect(last_request.url).to match(/files/)
    end
  end

  describe 'choosing directory to serve files from' do
    before do
      allow(file_list).to receive(:each_with_index)
      allow(file_list).to receive(:size).and_return(0)
    end

    context 'when no directory is specified' do
      it 'will use default directory' do
        expect(Ferver::FileList).to receive(:new).with('./').and_return(file_list)

        get '/files'
      end
    end

    context 'when the directory passed via configuration' do
      before do
        Ferver.configure do |conf|
          conf.directory_path = '/foo'
        end
      end

      it 'will use directory specified' do
        expect(Ferver::FileList).to receive(:new).with('/foo').and_return(file_list)

        get '/files'
      end
    end

    context 'when directory does not exist' do
      before do
        allow(Ferver::FileList).to receive(:new).and_raise(Ferver::DirectoryNotFoundError)
      end

      it 'will return server error status' do
        get '/files'

        expect(last_response.status).to eql 500
      end
    end
  end

  context 'given an empty list of files' do
    before do
      allow(file_list).to receive(:each_with_index)
      allow(file_list).to receive(:size).and_return(0)
      allow(Ferver::FileList).to receive(:new).and_return(file_list)
    end

    context 'when no content-type is requested' do
      before { get '/files' }

      it 'should return valid response' do
        expect(last_response).to be_ok
      end

      it 'should contain no file list in response content' do
        expect(last_response.body).not_to have_tag('li')
        expect(last_response.body).to have_tag('p', text: /0 files/)
      end
    end

    context 'when json content-type is requested' do
      before do
        allow(file_list).to receive(:map).and_return([])

        get '/files', {}, 'HTTP_ACCEPT' => 'application/json'
      end

      it 'should return valid response' do
        expect(last_response).to be_ok
        expect(last_response.content_type).to include('application/json')
      end

      it 'should contain no file list in response content' do
        list = JSON.parse last_response.body
        expect(list).to eq(EMPTY_FILE_LIST)
      end
    end
  end

  context 'given a list of files' do
    let(:file_1) { double('file', name: 'file1') }
    let(:file_2) { double('file', name: 'file2') }
    before do
      allow(file_list).to receive(:each_with_index).and_yield(file_1, 1).and_yield(file_2, 2)
      allow(file_list).to receive(:size).and_return(2)
      allow(Ferver::FileList).to receive(:new).and_return(file_list)
    end

    describe 'file list request' do

      context 'when no content-type is requested' do
        before { get '/files' }

        it 'should return valid response' do
          expect(last_response).to be_ok
        end

        it 'should contain no file list in response content' do
          expect(last_response.body).to have_tag('li', count: 2)
          expect(last_response.body).to have_tag('p', text: /2 files/)
        end

        it 'should list filenames' do
          expect(last_response.body).to have_tag('li') do
            with_tag('a', text: 'file1')
            with_tag('a', text: 'file2')
          end
        end
      end

      context 'when json content-type is requested' do
        before do
          allow(file_list).to receive(:map).and_return([file_1.name, file_2.name])

          get '/files', {}, 'HTTP_ACCEPT' => 'application/json'
        end

        it 'should return valid response' do
          expect(last_response).to be_ok
          expect(last_response.content_type).to include('application/json')
        end

        it 'should contain no file list in response content' do
          list = JSON.parse last_response.body
          expect(list.count).to eq(2)
          expect(list).to match_array([file_1.name, file_2.name])
        end
      end
    end

    describe 'downloading a file' do

      context 'when requesting a file out of range' do
        before do
          allow(file_list).to receive(:file_by_id).with(3).and_raise(IndexError)
          get '/files/3'
        end

        it 'should return not_found' do
          expect(last_response).to be_not_found
        end
      end

      context 'when requesting invalid file id' do
        before { get '/files/foo' }

        it 'should return not_found' do
          expect(last_response).to be_bad_request
        end
      end

      context 'when requesting a valid file id' do
        before { get '/files/0' }

        xit 'should return ok response' do
          expect(last_response).to be_ok
        end

        xit 'should return octet-stream content-type' do
          expect(last_response.headers['Content-Type']).to eq('application/octet-stream')
        end

      end
    end
  end
end

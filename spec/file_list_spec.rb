require 'spec_helper'

describe Ferver::FileList do
  before { allow(Dir).to receive(:exist?).and_return(true) }
  subject { Ferver::FileList.new('/foo') }

  describe 'creating instance' do
    context 'when empty path argument is passed' do
      it 'should raise exception if no argument passed' do
        expect { Ferver::FileList.new }.to raise_error(ArgumentError)
      end
    end

    context 'when valid path argument is passed' do
      let(:path) { '/foo' }

      it 'should find files in path argument' do
        expect(Dir).to receive(:foreach).with(path).and_return(EMPTY_FILE_LIST)

        Ferver::FileList.new(path)
      end
    end

    context 'when path argument passed does not exist' do
      let(:path) { '/foo' }

      it 'should test if directory exists' do
        expect(Dir).to receive(:exist?).with(path).and_return(true)
        allow(Dir).to receive(:foreach).with(path).and_return(EMPTY_FILE_LIST)

        Ferver::FileList.new(path)
      end

      it 'should raise exception' do
        allow(Dir).to receive(:exist?).with(path).and_return(false)

        expect { Ferver::FileList.new(path) }.to raise_error(Ferver::DirectoryNotFoundError)
      end
    end
  end

  context 'when path directory is empty' do
    before { allow(Dir).to receive(:foreach).and_return(EMPTY_FILE_LIST) }

    it 'should have zero #file_count' do
      expect(subject.file_count).to eq(0)
    end

    it 'should return empty array of files' do
      expect(subject.files).to eq(EMPTY_FILE_LIST)
    end
  end

  context 'when path directory contains current working dir and parent' do
    before(:each) do
      allow(Dir).to receive(:foreach).and_yield('.').and_yield('.').and_yield('file1')
      allow(File).to receive(:file?).and_return(true)
    end

    it 'should not count current working dir and parent' do
      expect(subject.file_count).to eq(1)
    end

    it 'should not include current working dir and parent' do
      expect(subject.files).to eq(['file1'])
    end
  end

  context 'when path directory contains file and directory' do
    before(:each) do
      allow(Dir).to receive(:foreach).and_yield('file1').and_yield('a_directory')
      allow(File).to receive(:file?).twice.and_return(true, false)
    end

    it 'should not count the directory' do
      expect(subject.file_count).to eq(1)
    end

    it 'should not include the directory' do
      expect(subject.files).to eq(['file1'])
    end
  end

  context 'when path directory contains valid files' do
    before do
      allow(Dir).to receive(:foreach).and_yield('file1').and_yield('file2')
      allow(File).to receive(:file?).twice.and_return(true)
    end

    it 'should count all files' do
      expect(subject.file_count).to eq(2)
    end

    it 'should list all files' do
      expect(subject.files).to eq(%w(file1 file2))
    end
  end

  describe 'requesting files' do
    before(:each) do
      allow(Dir).to receive(:foreach).and_yield('file1').and_yield('file2')
      allow(File).to receive(:file?).and_return(true)
    end

    context 'when requesting valid file_id' do
      # TODO: possible to redesign this

      it '#file_id_is_valid? should return true for first file' do
        expect(subject.file_id_is_valid?(0)).to be_truthy
      end

      it '#file_id_is_valid? should return true for second file' do
        expect(subject.file_id_is_valid?(1)).to be_truthy
      end

      it '#file_by_id should return the correct file for the first file' do
        expect(subject.file_by_id(0)).to eq('file1')
      end

      it '#file_by_id should return the correct file for the second file' do
        expect(subject.file_by_id(1)).to eq('file2')
      end
    end

    context 'when requesting invalid file_id' do
      it 'should return false for invalid file_id' do
        expect(subject.file_id_is_valid?(2)).to be_falsey
      end

      it 'should raise_error if file_by_id is called' do
        expect { subject.file_by_id(2) }.to raise_error(IndexError)
      end
    end
  end
end

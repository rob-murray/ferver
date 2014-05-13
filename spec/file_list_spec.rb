require 'spec_helper'

describe Ferver::FileList do

  before { Dir.stubs(:exist?).returns(true) }

  describe 'creating instance' do

    context 'when empty path argument is passed' do

      it 'should raise exception if no argument passed' do
        expect { Ferver::FileList.new }.to raise_error(ArgumentError)
      end

    end

    context 'when valid path argument is passed' do

      let(:path) { '/foo' }

      it 'should find files in path argument' do
        Dir.expects(:foreach).with(path).returns(EMPTY_FILE_LIST)
        Ferver::FileList.new(path)
      end

    end

    context 'when path argument passed does not exist' do

      let(:path) { '/foo' }

      it 'should test if directory exists' do
        Dir.expects(:exist?).with(path).returns(true)
        Dir.stubs(:foreach).returns(EMPTY_FILE_LIST)

        Ferver::FileList.new(path)
      end

      it 'should raise exception' do
        Dir.stubs(:exist?).returns(false)
        expect { Ferver::FileList.new(path) }.to raise_error(Ferver::DirectoryNotFoundError)
      end

    end

  end

  context 'when path directory is empty' do

    let(:file_list) { Ferver::FileList.new('/foo') }

    before { Dir.stubs(:foreach).returns(EMPTY_FILE_LIST) }

    it 'should have zero #file_count' do
      expect(file_list.file_count).to eq(0)
    end

    it 'should return empty array of files' do
      expect(file_list.files).to eq(EMPTY_FILE_LIST)
    end

  end

  context 'when path directory contains current working dir and parent' do

    let(:file_list) { Ferver::FileList.new('/foo') }

    before(:each) do
      Dir.stubs(:foreach).multiple_yields('.', '..', 'file1')
      File.stubs(:file?).returns(true)
    end

    it 'should not count current working dir and parent' do
      expect(file_list.file_count).to eq(1)
    end

    it 'should not include current working dir and parent' do
      expect(file_list.files).to eq(['file1'])
    end

  end

  context 'when path directory contains file and directory' do

    let(:file_list) { Ferver::FileList.new('/foo') }

    before(:each) do
      Dir.stubs(:foreach).multiple_yields('file1', 'a_directory')
      File.expects(:file?).at_most(2).returns(true, false)
    end

    it 'should not count the directory' do
      expect(file_list.file_count).to eq(1)
    end

    it 'should not include the directory' do
      expect(file_list.files).to eq(['file1'])
    end

  end

  context 'when path directory contains valid files' do

    let(:file_list) { Ferver::FileList.new('/foo') }

    before do
      Dir.stubs(:foreach).multiple_yields('file1', 'file2')
      File.stubs(:file?).returns(true)
    end

    it 'should count all files' do
      expect(file_list.file_count).to eq(2)
    end

    it 'should list all files' do
      expect(file_list.files).to eq(%w(file1 file2))
    end

  end

  describe 'requesting files' do

    let(:file_list) { Ferver::FileList.new('/foo') }

    before do
      Dir.stubs(:foreach).multiple_yields('file1', 'file2')
      File.stubs(:file?).returns(true)
    end

    context 'when requesting valid file_id' do
      # TODO: poss to redesign this

      it '#file_id_is_valid? should return true for first file' do
        file_list.file_id_is_valid?(0).should be_true
      end

      it '#file_id_is_valid? should return true for second file' do
        file_list.file_id_is_valid?(1).should be_true
      end

      it '#file_by_id should return the correct file for the first file' do
        expect(file_list.file_by_id(0)).to eq('file1')
      end

      it '#file_by_id should return the correct file for the second file' do
        expect(file_list.file_by_id(1)).to eq('file2')
      end

    end

    context 'when requesting invalid file_id' do

      it 'should return false for invalid file_id' do
        file_list.file_id_is_valid?(2).should be_false
      end

      it 'should raise_error if file_by_id is called' do
        expect { file_list.file_by_id(2) }.to raise_error(IndexError)
      end

    end

  end

end

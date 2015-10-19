require 'spec_helper'

describe Ferver::FileList do
  let(:file_1) { double('file', name: 'file1') }
  let(:file_2) { double('file', name: 'file2') }

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
      expect(subject.size).to eq(0)
    end

    it 'should return empty array of files' do
      expect(subject.to_a).to eq(EMPTY_FILE_LIST)
    end
  end

  context 'when path directory contains current working dir and parent' do
    before(:each) do
      allow(Dir).to receive(:foreach).and_yield('.').and_yield('.').and_yield(file_1.name)
      allow(File).to receive(:file?).and_return(true)
      allow(File).to receive(:zero?).and_return(false)
    end

    it 'should not count current working dir and parent' do
      expect(subject.size).to eq(1)
    end

    it 'should not include current working dir and parent' do
      expect(subject.to_a.first.name).to eq(file_1.name)
    end
  end

  context 'when path directory contains file and directory' do
    before(:each) do
      allow(Dir).to receive(:foreach).and_yield(file_1.name).and_yield('a_directory')
      allow(File).to receive(:file?).twice.and_return(true, false)
      allow(File).to receive(:zero?).twice.and_return(false, true)
    end

    it 'should not count the directory' do
      expect(subject.size).to eq(1)
    end

    it 'should not include the directory' do
      expect(subject.to_a.first.name).to eq(file_1.name)
    end
  end

  context 'when path directory contains valid files' do
    let(:files) { [file_1.name, file_2.name] }
    before do
      allow(Dir).to receive(:foreach).and_yield(files[0]).and_yield(files[1])
      allow(File).to receive(:file?).twice.and_return(true)
      allow(File).to receive(:zero?).twice.and_return(false)
    end

    it 'should count all files' do
      expect(subject.size).to eq(2)
    end

    describe 'iterating over files list' do
      it 'should yield files in order' do
        i = 0
        subject.each do | file |
          expect(file.name).to eq(files[i])
          i += 1
        end
      end
    end
  end

  describe 'requesting files' do
    before(:each) do
      allow(Dir).to receive(:foreach).and_yield(file_1.name).and_yield(file_2.name)
      allow(File).to receive(:file?).and_return(true)
      allow(File).to receive(:zero?).and_return(false)
    end

    context 'when requesting valid file_id' do
      it '#file_by_id should return the correct file for the first file' do
        expect(subject.file_by_id(0).name).to eq(file_1.name)
      end

      it '#file_by_id should return the correct file for the second file' do
        expect(subject.file_by_id(1).name).to eq(file_2.name)
      end
    end

    context 'when requesting invalid file_id' do
      it 'should raise_error if file_by_id is called' do
        expect { subject.file_by_id(2) }.to raise_error(IndexError)
      end
    end
  end
end

require 'spec_helper'

describe Ferver::Configuration do
  subject { Ferver::Configuration.new }

  describe 'configured directory path' do

    context 'with no path set' do
      it 'should return default path' do
        expect(subject.directory_path).to eq(Ferver::DEFAULT_FILE_SERVER_DIR_PATH)
      end
    end

    context 'when directory is set' do
      let(:path) { '/foo/bar' }

      it 'should return default path' do
        subject.directory_path = path

        expect(subject.directory_path).to eq(path)
      end
    end
  end
end

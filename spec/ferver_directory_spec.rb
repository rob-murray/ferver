# frozen_string_literal: true
RSpec.describe Ferver::FerverDirectory do
  subject { described_class.new config }

  let(:config) { double("Ferver::Configuration", directory_path: path, serve_hidden?: serve_hidden) }
  let(:path) { "/dev" }
  let(:serve_hidden) { true }

  before do
    allow(Dir).to receive(:exist?).and_return true
  end

  describe "assertions" do
    context "when path is empty" do
      let(:path) { "" }

      it "raises error" do
        expect { described_class.new config }.to raise_error(ArgumentError, "No path is specified")
      end
    end

    context "when directory does not exist" do
      before do
        allow(Dir).to receive(:exist?).and_return false
      end

      it "raises error" do
        expect { described_class.new config }.to raise_error(Ferver::DirectoryNotFoundError)
      end
    end
  end

  describe "#path" do
    let(:path) { "/dev/random" }

    it "is the path from config" do
      expect(subject.path).to eq "/dev/random"
    end
  end

  describe "#full_path" do
    let(:path) { "./" }

    it "is the full path to directory" do
      expect(File).to receive(:expand_path).with("./").and_return("/my/home")
      expect(subject.full_path).to eq "/my/home"
    end
  end

  describe "#found_files" do
    before(:each) do
      allow(Dir).to receive(:foreach)
        .and_yield(".")
        .and_yield("..")
        .and_yield("zero file")
        .and_yield("normal_file.txt")
        .and_yield(".hidden")
      allow(File).to receive(:file?).at_most(3).times.and_return(true, true, true)
      allow(File).to receive(:zero?).at_most(3).times.and_return(true, false, false)
    end

    context "when configured to serve all files" do
      let(:serve_hidden) { true }

      it "returns list of files matched" do
        expect(subject.found_files.map(&:name)).to eq ["normal_file.txt", ".hidden"]
      end
    end

    context "when configured not to serve hidden files" do
      let(:serve_hidden) { false }

      it "returns list of files matched" do
        expect(subject.found_files.map(&:name)).to eq ["normal_file.txt"]
      end
    end
  end
end

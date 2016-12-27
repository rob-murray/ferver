# frozen_string_literal: true
require "spec_helper"

describe Ferver::Configuration do
  subject { described_class.new }

  describe "configured directory path" do
    context "with no path set" do
      it "should return default path" do
        expect(subject.directory_path).to eq(Ferver::DEFAULT_FILE_SERVER_DIR_PATH)
      end
    end

    context "when directory is set" do
      let(:path) { "/foo/bar" }

      it "should return default path" do
        subject.directory_path = path

        expect(subject.directory_path).to eq(path)
      end
    end
  end

  describe "serving all files" do
    context "with no configuration set" do
      it "is false by default" do
        expect(subject.serve_hidden?).to be false
      end
    end

    context "when configured to serve hidden" do
      it "is true" do
        subject.serve_hidden = true

        expect(subject.serve_hidden?).to be true
      end
    end
  end
end

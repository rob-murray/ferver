# frozen_string_literal: true
RSpec.describe Ferver::FileList do
  subject { described_class.new(files) }

  let(:files) { [] }

  describe "#size" do
    it "is the size of the files available" do
      expect(subject.size).to eq 0
    end

    context "with files" do
      let(:files) { three_files }

      it "is the size of the files available" do
        expect(subject.size).to eq 3
      end
    end
  end

  describe "#each" do
    let(:files) { three_files }

    it "responds to each_with_index" do
      expect(subject).to respond_to(:each_with_index)
    end

    it "returns yields files in sorted order" do
      ordered_file_names = %w(file1 file2 file3)
      i = 0

      subject.each do |actual_file|
        expect(actual_file.name).to eq ordered_file_names[i]
        i += 1
      end
    end
  end

  describe "#file_by_id" do
    context "with a request for a file index within range" do
      let(:files) { three_files }

      it "returns the file requested in sorted order" do
        expect(subject.file_by_id(0).name).to eq "file1"
        expect(subject.file_by_id(1).name).to eq "file2"
        expect(subject.file_by_id(2).name).to eq "file3"
      end
    end

    context "with a request for a file index out of range" do
      it "raises file not found error" do
        expect { subject.file_by_id(0) }.to raise_error(Ferver::FileNotFoundError, "File id=0 not found")
      end
    end
  end

  private

  def three_files
    [
      double("file", name: "file2"),
      double("file", name: "file3"),
      double("file", name: "file1")
    ]
  end
end

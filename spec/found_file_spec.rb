# frozen_string_literal: true
RSpec.describe Ferver::FoundFile do
  subject { described_class.new("/dir", "file") }

  describe "#name" do
    it "is the file name" do
      expect(subject.name).to eq "file"
    end
  end

  describe "#path_to_file" do
    it "is the full path to file" do
      expect(subject.path_to_file).to eq "/dir/file"
    end
  end

  describe "#valid?" do
    context "when file exists" do
      before do
        allow(File).to receive(:file?).and_return true
      end

      context "when file is not empty" do
        before do
          allow(File).to receive(:zero?).and_return false
        end

        it "is valid" do
          expect(subject).to be_valid
        end
      end

      context "when file is empty" do
        before do
          allow(File).to receive(:zero?).and_return true
        end

        it "is not valid" do
          expect(subject).not_to be_valid
        end
      end
    end

    context "when file does not exist" do
      before do
        allow(File).to receive(:file?).and_return false
      end

      it "is not valid" do
        expect(subject).not_to be_valid
      end
    end
  end
end

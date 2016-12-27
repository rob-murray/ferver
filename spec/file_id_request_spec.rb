# frozen_string_literal: true
require "spec_helper"

describe Ferver::FileIdRequest do
  describe "creating new instance" do
    context "when valid Integer is passed" do
      subject { Ferver::FileIdRequest.new(1) }

      it "should return expected value" do
        expect(subject.value).to eq(1)
      end
    end

    context "when nil argument is passed" do
      it "should be invalid" do
        id_request = Ferver::FileIdRequest.new(nil)

        expect(id_request.valid?).to be_falsey
      end
    end
  end

  describe "#value= method" do
    subject { Ferver::FileIdRequest.new }

    context "when valid Integer is passed" do
      before { subject.value = 1 }

      it "should be valid" do
        expect(subject.valid?).to be_truthy
      end

      it "should return expected value" do
        expect(subject.value).to eq(1)
      end
    end

    context "when valid String as Integer is passed" do
      before { subject.value = "1" }

      it "should be valid" do
        expect(subject.valid?).to be_truthy
      end

      it "should return expected value" do
        expect(subject.value).to eq(1)
      end
    end

    context "when a string is passed" do
      before { subject.value = "foo" }

      it "should be invalid" do
        expect(subject.valid?).to be_falsey
      end
    end

    context "when an empty string is passed" do
      it "should be invalid" do
        subject.value = ""

        expect(subject.valid?).to be_falsey
      end
    end
  end
end

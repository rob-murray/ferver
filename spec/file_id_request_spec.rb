require 'spec_helper'

describe Ferver::FileIdRequest do

  describe 'creating new instance' do

    context 'when valid Integer is passed' do

      let(:id_request) { Ferver::FileIdRequest.new(1) }

      it 'should create instance' do
        expect(id_request).not_to be_nil
      end

      it 'should return expected value' do
        expect(id_request.value).to eq(1)
      end

    end

    context 'when nil argument is passed' do

      it 'should be invalid' do
        id_request = Ferver::FileIdRequest.new(nil)
        expect(id_request.valid?).to be_false
      end

    end

  end

  describe '#value= method' do

    let(:id_request) { Ferver::FileIdRequest.new }

    context 'when valid Integer is passed' do

      before { id_request.value = 1 }

      it 'should be valid' do
        expect(id_request.valid?).to be_true
      end

      it 'should return expected value' do
        expect(id_request.value).to eq(1)
      end

    end

    context 'when valid String as Integer is passed' do

      before { id_request.value = '1' }

      it 'should be valid' do
        expect(id_request.valid?).to be_true
      end

      it 'should return expected value' do
        expect(id_request.value).to eq(1)
      end

    end

    context 'when a string is passed' do

      before { id_request.value = 'foo' }

      it 'should be invalid' do
        expect(id_request.valid?).to be_false
      end

    end

    context 'when an empty string is passed' do

      it 'should be invalid' do
        id_request.value = ''
        expect(id_request.valid?).to be_false
      end

    end

  end

end

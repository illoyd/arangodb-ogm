require 'spec_helper'

RSpec.describe ArangoDB::OGM::Type::DocumentHandle do
  let(:handle)   { 'example_vertices/1234' }
  let(:dh)       { ArangoDB::DocumentHandle.new(handle) }
  let(:document) { ExampleVertex.new(_id: handle) }

  describe '#serialize' do
    it 'serializes a string' do
      expect( subject.serialize(handle) ).to eq(handle)
    end

    it 'serializes a DH' do
      expect( subject.serialize(dh) ).to eq(handle)
    end

    it 'serializes a document' do
      expect( subject.serialize(document) ).to eq(handle)
    end
  end

  describe '#deserialize' do
    it 'deserializes a string' do
      expect( subject.deserialize(handle) ).to eq(dh)
    end

    it 'deserializes a DH' do
      expect( subject.deserialize(dh) ).to eq(dh)
    end

    it 'deserializes a document' do
      expect( subject.deserialize(document) ).to eq(dh)
    end
  end

end

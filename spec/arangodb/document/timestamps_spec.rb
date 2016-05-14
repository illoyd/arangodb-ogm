require './spec/spec_helper.rb'

class TimestampObject
  include ArangoDB::OGM::Vertex
  include ArangoDB::OGM::Document::Timestamps
end

describe ArangoDB::OGM::Document::Timestamps do

  context 'with a new object' do
    subject { TimestampObject.new }

    it 'sets created_at' do
      expect{ subject.save! }.to change(subject, :created_at).from(nil)
    end

    it 'sets updated_at' do
      expect{ subject.save! }.to change(subject, :updated_at).from(nil)
    end

  end # with a new object

  context 'with an existing object' do
    subject { TimestampObject.create! }

    it 'sets created_at' do
      expect{ subject.save! }.not_to change(subject, :created_at)
    end

    it 'sets updated_at' do
      expect{ subject.save! }.to change(subject, :updated_at)
    end

  end # with an existing object

end
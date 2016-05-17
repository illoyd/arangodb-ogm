require './spec/spec_helper.rb'

class ShadowExampleVertex < ExampleVertex
  attr_accessor :shadow
end

RSpec.describe ArangoDB::OGM::Document::AttributeAssignment do
  subject { ExampleVertex.new(name: old_name) }
  let(:k) { 'hello' }
  let(:v) { 'world' }

  context 'assigning via #[]' do

    it 'assigns via #[]' do
      expect{ subject[k] = v }.to change{ subject[k] }.from(nil).to(v)
    end
    
    it 'adds to the attributes hash' do
      expect{ subject[k] = v }.to change{ subject.attributes.keys.include?(k) }.from(false).to(true)
    end
    
    it 'responds to hello after assignment' do
      expect{ subject[k] = v }.to change{ subject.respond_to?(k) }.from(false).to(true)
    end

    it 'responds to hello= after assignment' do
      expect{ subject[k] = v }.to change{ subject.respond_to?("#{k}=") .from(false).to(true)
    end

  end

  context "assigning via #{k}=" do

    context 'when not already defined' do
      it 'fails' do
        expect{ subject.hello = v }.to raise_error(NotImplemented)
      end
    end
    
    context 'when defined' do
      before { subject[k] = 'mundo' }

      it 'assigns the new attribute' do
        expect{ subject.hello = v }.to change{ subject[k] }.from('mundo').to(v)
      end

      it 'adds to the attributes hash' do
        expect{ subject.hello = v }.to change{ subject.attributes.keys.include?(k) }.from(false).to(true)
      end

    end

  end
  
  context 'with existing assignment method' do
    it 'assigns the new attribute' do
      expect{ subject.shadow = v }.to change{ subject[k] }.from(nil).to(v)
    end

    it 'does not add to the attributes hash' do
      expect{ subject.shadow = v }.not_to change{ subject.attributes.keys.include?(k) }.from(false)
    end
  end

end
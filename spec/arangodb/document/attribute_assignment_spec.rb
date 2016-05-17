require './spec/spec_helper.rb'

class ShadowExampleVertex < ExampleVertex
  attr_accessor :shadow_quote
end

RSpec.describe ArangoDB::OGM::AttributeAssignment do
  subject { ExampleVertex.new(name: Faker::StarWars.character) }
  let(:quote) { Faker::StarWars.quote }

  context 'assigning via #[]' do

    it 'assigns via #[]' do
      expect{ subject['hello'] = quote }.to change{ subject['hello'] }.from(nil).to(quote)
    end

    it 'adds to the attributes hash' do
      expect{ subject['hello'] = quote }.to change{ subject.attributes.keys.include?('hello') }.from(false).to(true)
    end

    it 'responds to hello after assignment' do
      expect{ subject['hello'] = quote }.to change{ subject.respond_to?('hello') }.from(false).to(true)
    end

    it 'responds to hello= after assignment' do
      expect{ subject['hello'] = quote }.to change{ subject.respond_to?('hello=') }.from(false).to(true)
    end

  end

  context 'assigning via hello=' do

    context 'when not already defined' do
      it 'fails' do
        expect{ subject.hello = quote }.to raise_error(NoMethodError)
      end
    end

    context 'when defined' do
      before { subject['hello'] = 'mundo' }

      it 'assigns the new attribute' do
        expect{ subject.hello = quote }.to change{ subject['hello'] }.from('mundo').to(quote)
      end

      it 'adds to the attributes hash' do
        expect{ subject.hello = quote }.not_to change{ subject.attributes.keys.include?('hello') }.from(true)
      end

    end

  end

  context 'with existing assignment method' do
    subject { ShadowExampleVertex.new(name: Faker::StarWars.character) }

    it 'assigns the new attribute' do
      expect{ subject.shadow_quote = quote }.to change{ subject.shadow_quote }.from(nil).to(quote)
    end

    it 'does not add to the attributes hash' do
      expect{ subject.shadow_quote = quote }.not_to change{ subject.attributes.keys.include?('shadow_quote') }.from(false)
    end
  end

end
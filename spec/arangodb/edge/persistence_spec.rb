require './spec/spec_helper.rb'

RSpec.describe ArangoDB::OGM::Edge, 'persistence', :with_database do

  context 'with a new edge' do
    let(:from_obj) { ExampleVertex.create!(name: Faker::StarWars.character) }
    let(:to_obj)   { ExampleVertex.create!(name: Faker::StarWars.character) }
    let(:obj)      { ExampleEdge.new('_from' => from_obj.document_handle, '_to' => to_obj.document_handle) }
    before         { obj }

    describe ExampleEdge, '#save' do

      it 'creates a new entry' do
        expect{ obj.save }.to change{ obj.class.count }.by(1)
      end

      it 'changes persisted' do
        expect{ obj.save }.to change(obj, :persisted?).to(true)
      end

    end # .save

    describe ExampleEdge, '#save!' do

      it 'creates a new entry' do
        expect{ obj.save! }.to change{ obj.class.count }.by(1)
      end

      it 'changes persisted' do
        expect{ obj.save! }.to change(obj, :persisted?).to(true)
      end

    end # .save!

  end # with a new edge

  context 'with a persisted edge' do
    let(:from_obj) { ExampleVertex.create!(name: Faker::StarWars.character) }
    let(:to_obj)   { ExampleVertex.create!(name: Faker::StarWars.character) }
    let(:obj)      { ExampleEdge.create!('_from' => from_obj.document_handle, '_to' => to_obj.document_handle) }
    before         { obj }

    describe ExampleEdge, '#save' do

      it 'updates an existing entry' do
        expect{ obj.save }.not_to change{ obj.class.count }
      end

      it 'does not change persisted' do
        expect{ obj.save }.not_to change(obj, :persisted?)
      end

      it 'updates attribute' do
        expect{ obj['beer'] = Faker::Beer.name; obj.save }.to change{ ExampleEdge.find(obj.id)['beer'] }.from(nil)
      end

    end # .save

    describe ExampleEdge, '#save!' do

      it 'updates an existing entry' do
        expect{ obj.save! }.not_to change{ obj.class.count }
      end

      it 'does not change persisted' do
        expect{ obj.save! }.not_to change(obj, :persisted?)
      end

      it 'updates attribute' do
        expect{ obj['beer'] = Faker::Beer.name; obj.save! }.to change{ ExampleEdge.find(obj.id)['beer'] }.from(nil)
      end

    end # .save!

  end # with a persisted object

end
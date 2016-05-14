require './spec/spec_helper.rb'

RSpec.describe ArangoDB::OGM::Document, 'finders', :with_database do

  context 'with a persisted object' do
    let(:name) { Faker::StarWars.character }
    let(:beer) { Faker::Beer.name }
    let(:obj)  { ExampleVertex.create!('name' => name, 'beer' => beer) }
    let(:id)   { obj.id }

    before     { obj }

    describe ExampleVertex, '.find' do
      it 'finds by ID' do
        expect( described_class.find(id).id ).to eq(id)
      end

      it 'finds by string' do
        expect( described_class.find(id.to_s).id ).to eq(id)
      end

      it 'finds an ExampleVertex' do
        expect( described_class.find(id) ).to be_an(ExampleVertex)
      end

      it 'returns the name' do
        expect( described_class.find(id).name ).to eq(name)
      end

      it 'returns the beer' do
        expect( described_class.find(id).beer ).to eq(beer)
      end
    end # .find

    describe ExampleVertex, '.find!' do
      it 'finds by ID' do
        expect( described_class.find!(id).id ).to eq(id)
      end

      it 'finds by string' do
        expect( described_class.find!(id.to_s).id ).to eq(id)
      end

      it 'finds an ExampleVertex' do
        expect( described_class.find!(id) ).to be_an(ExampleVertex)
      end

    end # .find!

    describe ExampleVertex, '.find_by' do

      it 'finds the vertex by name' do
        expect( described_class.find_by('name' => name).id ).to eq(id)
      end

      it 'finds the vertex by beer' do
        expect( described_class.find_by('beer' => beer).id ).to eq(id)
      end

    end # .find_by

    describe ExampleVertex, '.find_by!' do

      it 'finds the vertex by name' do
        expect( described_class.find_by!('name' => name).id ).to eq(id)
      end

      it 'finds the vertex by beer' do
        expect( described_class.find_by!('beer' => beer).id ).to eq(id)
      end

    end # .find_by!

    describe ExampleVertex, '.where' do

      it 'finds the vertex by name as an array' do
        expect( described_class.where('name' => name).map(&:id) ).to eq([id])
      end

      it 'finds the vertex by beer as an array' do
        expect( described_class.where('beer' => beer).map(&:id) ).to eq([id])
      end

    end # .where

  end # with a persisted object

  context 'without a persisted object' do
    let(:id)   { 1234 }
    let(:name) { Faker::StarWars.character }
    let(:beer) { Faker::Beer.name }

    describe ExampleVertex, '.find' do
      it 'returns nil' do
        expect( described_class.find(id) ).to be_nil
      end
    end # .find

    describe ExampleVertex, '.find!' do
      it 'raises an error' do
        expect{ described_class.find!(id) }.to raise_error(ArangoDB::API::ResourceNotFound)
      end
    end # .find!

    describe ExampleVertex, '.find_by' do

      it 'returns nil for find by name' do
        expect( described_class.find_by('name' => name) ).to be_nil
      end

      it 'returns nil for find by beer' do
        expect( described_class.find_by('beer' => beer) ).to be_nil
      end

    end # .find_by

    describe ExampleVertex, '.find_by!' do

      it 'finds the vertex by name' do
        expect{ described_class.find_by!('name' => name) }.to raise_error(ArangoDB::API::ResourceNotFound)
      end

      it 'finds the vertex by beer' do
        expect{ described_class.find_by!('beer' => beer) }.to raise_error(ArangoDB::API::ResourceNotFound)
      end

    end # .find_by!

    describe ExampleVertex, '.where' do

      it 'finds an empty array for find by name' do
        expect( described_class.where('name' => name) ).to be_empty
      end

      it 'finds an empty array for find by beer' do
        expect( described_class.where('beer' => beer) ).to be_empty
      end

    end # .where

  end # without a persisted object

  context 'with several persisted objects' do
    before { 3.times { ExampleVertex.create! } }

    describe ExampleVertex, '.all' do
      it 'returns 3 items' do
        expect( described_class.all.size ).to eq(3)
      end

      it 'returns ExampleVertices' do
        expect( described_class.all.all? { |obj| obj.is_a?(ExampleVertex) } ).to be_truthy
      end
    end

  end # with several persisted objects

end
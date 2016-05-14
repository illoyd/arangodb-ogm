require './spec/spec_helper.rb'

RSpec.describe ArangoDB::OGM::Vertex::Edges do

  class Person
    include ArangoDB::OGM::Vertex
  end

  class Beer
    include ArangoDB::OGM::Vertex
  end

  class Know
    include ArangoDB::OGM::Edge
  end

  class Drink
    include ArangoDB::OGM::Edge
  end

  def create_graph
    ArangoDB::OGM.graph_name = 'arangodb_drinks_graph'
    ArangoDB::OGM.graph.create('name' => ArangoDB::OGM.graph_name, "edgeDefinitions" => [
      {
        "collection" => Know.collection_name,
        "from"       => [ Person.collection_name ],
        "to"         => [ Person.collection_name ]
      },
      {
        "collection" => Drink.collection_name,
        "from"       => [ Person.collection_name ],
        "to"         => [ Beer.collection_name ]
      }
    ] ) unless ArangoDB::OGM.graph.exists?
  end

  def drop_graph
    ArangoDB::OGM.graph_name = 'arangodb_drinks_graph'
    ArangoDB::OGM.graph.delete if ArangoDB::OGM.graph.exists?
  end

  before(:all) { create_graph }
  after(:all)  { drop_graph }

  context 'with a graph' do
    let(:personA)  { Person.create!(name: Faker::StarWars.character) }
    let(:personB)  { Person.create!(name: Faker::StarWars.character) }
    let(:personC)  { Person.create!(name: Faker::StarWars.character) }
    let(:beerX)    { Beer.create!(name: Faker::Beer.name) }
    let(:beerY)    { Beer.create!(name: Faker::Beer.name) }
    let(:knowsAB)  { Know.create!('from' => personA, 'to' => personB) }
    let(:knowsAC)  { Know.create!('from' => personA, 'to' => personC) }
    let(:knowsBC)  { Know.create!('from' => personB, 'to' => personC) }
    let(:drinksAY) { Drink.create!('from' => personA, 'to' => beerY) }
    let(:drinksBX) { Drink.create!('from' => personB, 'to' => beerX) }
    let(:drinksCX) { Drink.create!('from' => personC, 'to' => beerX) }
    before         { knowsAB; knowsAC; knowsBC; drinksAY; drinksBX; drinksCX }

    describe '#edges' do

      it 'finds all neighbours from Person A' do
        expect( personA.edges.map(&:id) ).to match_array([ personB, personC, beerY ].map(&:id))
      end

      it 'finds all Knows (by collection name) from Person A' do
        expect( personA.edges(Know.collection_name).map(&:id) ).to match_array([ personB, personC ].map(&:id))
      end

      it 'finds all Knows (by class) from Person A' do
        expect( personA.edges(Know).map(&:id) ).to match_array([ personB, personC ].map(&:id))
      end

      it 'finds all Drinks (by collection name) from Person A' do
        expect( personA.edges(Drink.collection_name).map(&:id) ).to match_array([ beerY ].map(&:id))
      end

      it 'finds all Drinks (by class) from Person A' do
        expect( personA.edges(Drink).map(&:id) ).to match_array([ beerY ].map(&:id))
      end

    end

  end # with a graph

end
require './spec/spec_helper.rb'

describe ArangoDB::OGM::Document, 'attributes' do

  context 'change detection' do
    let(:old_name) { 'Old' }
    let(:new_name) { 'New' }
    subject { ExampleVertex.new(name: old_name) }

    context 'via attribute assignment' do
      it 'detects change with different value' do
        expect{ subject.name = new_name }.to change(subject, :changed).from([]).to(['name'])
      end

      it 'ignores change with same value' do
        expect{ subject.name = old_name }.not_to change(subject, :changed).from([])
      end
    end

    context 'via hash assignment with symbol' do
      it 'detects change with different value' do
        expect{ subject[:name] = new_name }.to change(subject, :changed).from([]).to(['name'])
      end

      it 'ignores change with same value' do
        expect{ subject[:name] = old_name }.not_to change(subject, :changed).from([])
      end
    end

    context 'via hash assignment with string' do
      it 'detects change with different value' do
        expect{ subject['name'] = new_name }.to change(subject, :changed).from([]).to(['name'])
      end

      it 'ignores change with same value' do
        expect{ subject['name'] = old_name }.not_to change(subject, :changed).from([])
      end
    end

  end

  context '#presence?' do
    subject { ExampleVertex.new(name: 'my name', with_null: nil, with_blank: '', with_spaces: '  ') }

    it 'detects name' do
      expect( subject.name? ).to be_truthy
    end

    it 'does not detect with_null' do
      expect( subject.with_null? ).to be_falsey
    end

    it 'does not detect with_blank' do
      expect( subject.with_blank? ).to be_falsey
    end

    it 'does not detect with_spaces' do
      expect( subject.with_spaces? ).to be_falsey
    end
  end

end
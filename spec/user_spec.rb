require 'spec_helper'

describe Bitgo::User do
  let(:session) { double(:session) }
  let(:user) { Bitgo::User.new(session, data) }

  describe '#id' do
    let(:data) { { 'id' => 'blah' } }

    it 'returns default id' do
      expect(Bitgo::User.new(session).id).to be_nil
    end

    it 'returns value from raw_data' do
      expect(user.id).to eq data['id']
    end
  end

  describe 'name' do
    let(:data) do
      { 'name' => { 'first' => 'Juan',
                    'last'  => 'dela Cruz',
                    'full'  => 'Juan dela Cruz'} }
    end

    describe '#first_name' do
      it 'returns default' do
        expect(Bitgo::User.new(session).first_name).to be_nil
      end

      it 'returns value from raw_data' do
        expect(user.first_name).to eq data['name']['first']
      end
    end

    describe '#last_name' do
      it 'returns default' do
        expect(Bitgo::User.new(session).last_name).to be_nil
      end

      it 'returns value from raw_data' do
        expect(user.last_name).to eq data['name']['last']
      end
    end

    describe '#full_name' do
      it 'returns default' do
        expect(Bitgo::User.new(session).full_name).to be_nil
      end

      it 'returns value from raw_data' do
        expect(user.full_name).to eq data['name']['full']
      end
    end
  end

  describe '#active?' do
    let(:data) { { 'isActive' => true } }
    it 'returns default value' do
      expect(Bitgo::User.new(session).active?).to eq nil
    end

    it 'returns value from raw_data' do
      expect(user).to be_active
    end
  end

  describe '.me!' do
    before do
      allow(session).to receive(:call) { get_fixture('user.json') }
    end

    it 'returns User object' do
      expect(Bitgo::User.me!(session)).to be_instance_of Bitgo::User
    end
  end
end

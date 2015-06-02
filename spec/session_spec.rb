require 'spec_helper'

describe Bitgo::Session do
  let(:options) { get_fixture('session.json') }
  let(:session) { Bitgo::Session.new(options) }

  specify '#access_token' do
    expect(session.access_token).to eq options['access_token']
  end

  specify '#expires_in' do
    expect(session.expires_in).to eq options['expires_in']
  end

  specify '#token_type' do
    expect(session.token_type).to eq options['token_type']
  end

  describe '#user' do
    it 'returns User object' do
      expect(session.user).to be_instance_of Bitgo::User
    end

    it 'returns user' do
      expect(session.user.id).to eq options['user']['id']
    end
  end
end

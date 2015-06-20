require 'spec_helper'

describe Bitgo::AccessToken do
  let(:options) { get_fixture('access_token.json') }
  let(:access_token) { Bitgo::AccessToken.new(options) }

  specify '#access_token' do
    expect(access_token.access_token).to eq options['access_token']
  end

  specify '#expires_in' do
    expect(access_token.expires_in).to eq options['expires_in']
  end

  specify '#token_type' do
    expect(access_token.token_type).to eq options['token_type']
  end

  describe '#user' do
    it 'returns User object' do
      expect(access_token.user).to be_instance_of Bitgo::User
    end

    it 'returns user' do
      expect(access_token.user.id).to eq options['user']['id']
    end
  end
end

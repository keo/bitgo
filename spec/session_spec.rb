require 'spec_helper'

RSpec.describe Bitgo::Session do
  let(:token) { double(:token, access_token: 'myaccesstoken') }
  let(:data) { get_fixture('session.json') }
  subject { described_class.new(token, data) }

  describe 'attributes' do
    specify(:client) { expect(subject.client).to eq data['client'] }
    specify(:user) { expect(subject.user).to eq data['user'] }
    specify(:expires) { expect(subject.expires).to eq data['expires'] }
    specify(:origin) { expect(subject.origin).to eq data['origin'] }
    specify(:scope) { expect(subject.scope).to match_array data['scope'] }
  end

  describe '#unlock' do
    before do
      stub_request(:post, 'https://test.bitgo.com/api/v1/user/unlock').
        to_return(body: get_fixture('session.json').to_json)
    end

    it 'returns the updated itself' do
      expect(subject.unlock('otp' => 'xx')).to be_instance_of Bitgo::Session
    end
  end

  describe '.get' do
    before do
      stub_request(:get, 'https://test.bitgo.com/api/v1/user/session').
        to_return(body: get_fixture('session.json').to_json, status: 200)
    end

    it 'instantiate session from token' do
      expect(Bitgo::Session.get(token)).to be_instance_of Bitgo::Session
    end
  end
end

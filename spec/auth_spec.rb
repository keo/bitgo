require 'spec_helper'

describe Bitgo::Auth do
  let(:options) do
    { 'email' => 'janedoe@bitgo.com',
      'password' => 'mypassword',
      'otp' => '123123123' }
  end
  let(:auth) { Bitgo::Auth.new(options) }
  let(:success_response) do
    double(:response, body: get_fixture('session.json').to_json)
  end

  specify '#encrypted_password' do
    expect(auth.encrypted_password).to eq '8d7bac7712d99ba1c6b40792e856dda926408e1a0c51a8a8dc10cb03a9ba6d2b'
  end

  describe '#call' do
    before do
      allow_any_instance_of(Net::HTTP).to receive(:request) { success_response }
    end

    it 'returns session object' do
      expect(Bitgo::Auth.new(options).call).to be_instance_of Bitgo::Session
    end
  end
end

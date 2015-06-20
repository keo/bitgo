require 'spec_helper'

describe Bitgo::Auth do
  let(:options) do
    { 'email' => 'janedoe@bitgo.com',
      'password' => 'mypassword',
      'otp' => '123123123' }
  end
  let(:auth) { Bitgo::Auth.new(options) }
  specify '#encrypted_password' do
    expect(auth.encrypted_password).to eq '8d7bac7712d99ba1c6b40792e856dda926408e1a0c51a8a8dc10cb03a9ba6d2b'
  end

  describe '#call' do

    context 'on success' do
      let(:response) do
        double(:response, code: '200', body: get_fixture('session.json').to_json)
      end

      before do
        allow_any_instance_of(Net::HTTP).to receive(:request) { response }
      end

      it 'returns session object' do
        expect(Bitgo::Auth.new(options).call).to be_instance_of Bitgo::AccessToken
      end
    end

    context 'on bad request error'  do
      let(:response) do
        double(:response, code: '400', body: '{}')
      end

      before do
        allow_any_instance_of(Net::HTTP).to receive(:request) { response }
      end

      it 'raise a BadRequestError' do
        expect do
          Bitgo::Auth.new(options).call
        end.to raise_error Bitgo::Auth::BadRequestError
      end
    end

    context 'on unauthorized error'  do
      let(:response) do
        double(:response, code: '401', body: '{}')
      end

      before do
        allow_any_instance_of(Net::HTTP).to receive(:request) { response }
      end

      it 'raises unauthorized error' do
        expect do
          Bitgo::Auth.new(options).call
        end.to raise_error Bitgo::Auth::UnauthorizedError
      end
    end
  end
end

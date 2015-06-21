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
      before do
        stub_request(:post, 'https://test.bitgo.com/api/v1/user/login').
          to_return(body: get_fixture('access_token.json').to_json, status: 200)

        stub_request(:get, 'https://test.bitgo.com/api/v1/user/session').
          to_return(body: get_fixture('session.json').to_json, status: 200)
      end

      it 'returns session object' do
        expect(Bitgo::Auth.new(options).call).to be_instance_of Bitgo::Session
      end
    end

    context 'on bad request error'  do
      before do
        stub_request(:post, 'https://test.bitgo.com/api/v1/user/login').
          to_return(body: '{}', status: 400)
      end

      it 'raise a BadRequestError' do
        expect do
          Bitgo::Auth.new(options).call
        end.to raise_error Bitgo::Auth::BadRequestError
      end
    end

    context 'on unauthorized error'  do
      before do
        stub_request(:post, 'https://test.bitgo.com/api/v1/user/login').
          to_return(body: '{}', status: 401)
      end

      it 'raises unauthorized error' do
        expect do
          Bitgo::Auth.new(options).call
        end.to raise_error Bitgo::Auth::UnauthorizedError
      end
    end
  end
end

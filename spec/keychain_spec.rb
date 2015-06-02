require 'spec_helper'

describe Bitgo::Keychain do
  let(:session) { double(:session) }

  describe '#create' do
    let(:params) {
      { "xpub" => "test 123 key pub",
        "encryptedXprv" => "oaeaoeu aeuaoeuaou" }
    }

    before do
      allow(session).to receive(:call) { get_fixture('keychain.json') }
    end

    it 'creates keychain' do
      response = Bitgo::Keychain.create(session, params)
      expect(response).not_to have_key ("error")
    end

    it 'creates bitgo keychain' do
      response = Bitgo::Keychain.new(session).create_bitgo
      expect(response).not_to have_key ("error")
    end
  end

  describe '#get' do
    before do
      allow(session).to receive(:call) { get_fixture('keychain.json') }
    end

    it 'returns kechain' do
      keychain = Bitgo::Keychain.new(session)
      response = keychain.get('xpub661MyMwAqRbcGQjyyTX5B1S2t78UStir1oFFHZLdLdpLiufL7hB4pPbJFnd9mpJXbHoq3dU7nU2NevzCsPHRqXpPYRh3QULWKxTZnB8FNat')

      expect(response).to have_key("xpub")
    end
  end

  describe '#update' do
    let(:xpub) { "xpub661MyMwAqRbcGQjyyTX5B1S2t78UStir1oFFHZLdLdpLiufL7hB4pPbJFnd9mpJXbHoq3dU7nU2NevzCsPHRqXpPYRh3QULWKxTZnB8FNat" }
    let(:params) {
      { "encryptedXprv" => "aoeaoeu aoeuathoesuha soetuhsatoehu satoheusatoheu",
        "xpub" => "xpub661MyMwAqRbcGQjyyTX5B1S2t78UStir1oFFHZLdLdpLiufL7hB4pPbJFnd9mpJXbHoq3dU7nU2NevzCsPHRqXpPYRh3QULWKxTZnB8FNat"}
    }

    before do
      allow(session).to receive(:call) { get_fixture('keychain.json') }
    end

    it 'updates keychain' do
      keychain = Bitgo::Keychain.new(session)
      response = keychain.update(params)
    end
  end
end

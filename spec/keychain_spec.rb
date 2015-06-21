require 'spec_helper'

describe Bitgo::Keychain do
  let(:token) { double(:token).as_null_object }
  let(:keychain) { Bitgo::Keychain.new(token, data) }

  describe '#xpub' do
    let(:data) { { 'xpub' => 'aoeuaoeu' } }

    it 'sets default xpub' do
      expect(Bitgo::Keychain.new(token).xpub).to be_nil
    end

    it 'sets value from raw_data' do
      expect(keychain.xpub).to eq data['xpub']
    end
  end

  describe '#bitgo?' do
    let(:data) { { 'isBitgo' => true } }
    it 'sets default' do
      expect(Bitgo::Keychain.new(token).bitgo?).to be_nil
    end

    it 'sets bitgo' do
      expect(keychain).to be_bitgo
    end
  end

  describe '#path' do
    let(:data) { { 'path' => '0/0' } }
    it 'sets default value' do
      expect(Bitgo::Keychain.new(token).path).to be_nil
    end

    it 'sets value from raw_data' do
      expect(keychain.path).to eq data['path']
    end
  end

  describe '#xprv' do
    let(:data) { { 'xprv' => 'aoeu12342' } }
    it 'sets default value' do
      expect(Bitgo::Keychain.new(token).xprv).to be_nil
    end

    it 'sets value from raw_data' do
      expect(keychain.xprv).to eq data['xprv']
    end
  end

  describe '#encrypted_xprv' do
    let(:data) { { 'encryptedXprv' => 'aoeuaeuthth123h1t2h3t12' } }

    it 'sets default value' do
      expect(Bitgo::Keychain.new(token).encrypted_xprv).to be_nil
    end

    it 'sets value from raw_data' do
      expect(keychain.encrypted_xprv).to eq data['encryptedXprv']
    end
  end

  describe '.create' do
    let(:params) do
      { "xpub" => "test 123 key pub",
        "encryptedXprv" => "oaeaoeu aeuaoeuaou" }
    end
    let(:raw_data) { get_fixture('keychain.json') }

    before do
      stub_request(:post, "https://test.bitgo.com/api/v1/keychain").
        to_return({ body: raw_data.to_json})
    end

    it 'creates keychain' do
      keychain = Bitgo::Keychain.create(token, params)
      expect(keychain).to be_instance_of Bitgo::Keychain
      expect(keychain.xpub).to eq raw_data['xpub']
    end

    it 'creates bitgo keychain' do
      stub_request(:post, "https://test.bitgo.com/api/v1/keychain/bitgo").
        to_return({ body: raw_data.to_json})
      keychain = Bitgo::Keychain.create_bitgo(token)
      expect(keychain).to be_instance_of Bitgo::Keychain
    end
  end

  describe '.get' do
    before do
      stub_request(:post, "https://test.bitgo.com/api/v1/keychain/xpubkey").
        to_return(body: get_fixture('keychain.json').to_json, status: 200)
    end

    it 'returns kechain' do
      keychain = Bitgo::Keychain.get(token, 'xpubkey')
      expect(keychain).to be_instance_of Bitgo::Keychain
    end

    context 'when needs unlock' do
      let(:error_response) do
        { 'error' => 'needs unlock',
          'needsOTP' => true,
          'needsUnlock' => true }
      end

      let(:raw_response) do
        double(:response, code: '401', body: error_response.to_json)
      end

      before do
        stub_request(:post, "https://test.bitgo.com/api/v1/keychain/xpubkey").
          to_return(body: error_response.to_json, status: 401)
      end

      it 'raises needs unlock error' do
        expect { Bitgo::Keychain.get(token, 'xpubkey') }.
          to raise_error Bitgo::NeedsUnlockError
      end
    end
  end

  describe '.list' do
    before do
      stub_request(:get, "https://test.bitgo.com/api/v1/keychain").
        to_return(body: get_fixture('keychains.json').to_json)
    end

    it 'returns an array of keychain object' do
      keychains = Bitgo::Keychain.list(token)
      expect(keychains.first).to be_instance_of Bitgo::Keychain
    end
  end

  describe '#update' do
    let(:xpub) { "myxpub" }
    let(:keychain) do
      Bitgo::Keychain.new(token, { 'xpub' => xpub,
                                     'encryptedXprv' => 'oldxprv' })
    end
    let(:params) do
      { "encryptedXprv" => "newxprv" }
    end
    let(:response_data) do
      {
        "xpub" => "xpub661MyMwAqRbcGzVAChrAGb6MYDrAXndUC7h8T7AF8UhfbjS7Au7UKTXmVXaFasQPdfmnUjccreRTMrW7kTmjzwMqVrTHNAFs8M3CXTJpcnL",
        "encryptedXprv" => "newxprv",
        "path" => "m"
      }
    end

    before do
      stub_request(:put, "https://test.bitgo.com/api/v1/keychain/myxpub").
        and_return(body: response_data.to_json)
    end

    it 'returns updated keychain' do
      expect do
        keychain.update(params)
      end.to change { keychain.encrypted_xprv }.from("oldxprv").to("newxprv")
    end
  end
end

require 'spec_helper'

describe Bitgo::Keychain do
  let(:session) { double(:session) }
  let(:keychain) { Bitgo::Keychain.new(session, data) }

  describe '#xpub' do
    let(:data) { { 'xpub' => 'aoeuaoeu' } }

    it 'sets default xpub' do
      expect(Bitgo::Keychain.new(session).xpub).to be_nil
    end

    it 'sets value from raw_data' do
      expect(keychain.xpub).to eq data['xpub']
    end
  end

  describe '#bitgo?' do
    let(:data) { { 'isBitgo' => true } }
    it 'sets default' do
      expect(Bitgo::Keychain.new(session).bitgo?).to be_nil
    end

    it 'sets bitgo' do
      expect(keychain).to be_bitgo
    end
  end

  describe '#path' do
    let(:data) { { 'path' => '0/0' } }
    it 'sets default value' do
      expect(Bitgo::Keychain.new(session).path).to be_nil
    end

    it 'sets value from raw_data' do
      expect(keychain.path).to eq data['path']
    end
  end

  describe '#xprv' do
    let(:data) { { 'xprv' => 'aoeu12342' } }
    it 'sets default value' do
      expect(Bitgo::Keychain.new(session).xprv).to be_nil
    end

    it 'sets value from raw_data' do
      expect(keychain.xprv).to eq data['xprv']
    end
  end

  describe '#encrypted_xprv' do
    let(:data) { { 'encryptedXprv' => 'aoeuaeuthth123h1t2h3t12' } }

    it 'sets default value' do
      expect(Bitgo::Keychain.new(session).encrypted_xprv).to be_nil
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
      allow(session).to receive(:call) { raw_data }
    end

    it 'creates keychain' do
      keychain = Bitgo::Keychain.create(session, params)
      expect(keychain).to be_instance_of Bitgo::Keychain
      expect(keychain.xpub).to eq raw_data['xpub']
    end

    it 'creates bitgo keychain' do
      keychain = Bitgo::Keychain.create_bitgo(session)
      expect(keychain).to be_instance_of Bitgo::Keychain
    end
  end

  describe '.get' do
    before do
      allow(session).to receive(:call) { get_fixture('keychain.json') }
      allow(session).to receive(:raw_response) { double(:response, code: '200') }
    end

    it 'returns kechain' do
      keychain = Bitgo::Keychain.get(session, 'xpubkey')
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
        allow(session).to receive(:call) { error_response }
        allow(session).to receive(:raw_response) { raw_response }
      end

      it 'raises needs unlock error' do
        expect { Bitgo::Keychain.get(session, 'xpubkey') }.
          to raise_error Bitgo::NeedsUnlockError
      end
    end
  end

  describe '.list' do
    before do
      allow(session).to receive(:call) { get_fixture('keychains.json') }
    end

    it 'returns an array of keychain object' do
      keychains = Bitgo::Keychain.list(session)
      expect(keychains.first).to be_instance_of Bitgo::Keychain
    end
  end

  describe '#update' do
    let(:xpub) { "myxpub" }
    let(:keychain) do
      Bitgo::Keychain.new(session, { 'xpub' => xpub,
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
      allow(session).to receive(:call) { response_data }
    end

    it 'returns updated keychain' do
      expect do
        keychain.update(params)
      end.to change { keychain.encrypted_xprv }.from("oldxprv").to("newxprv")
    end
  end
end

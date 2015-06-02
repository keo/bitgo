require 'spec_helper'

describe Bitgo::Wallet do
  let(:session) { double(:session) }

  describe '#list' do
    before do
      allow(session).to receive(:call) { get_fixture('wallets.json') }
    end

    it 'returns list of wallets' do
      wallets = Bitgo::Wallet.list(session)
      expect(wallets).to have_key('wallets')
    end
  end

  describe '#add' do
    let(:params) do
      { 'label' => 'My Wallet',
        'm' => 2,
        'n' => 3,
        'keychains' => [
          {'xpub' => 'xPub of user keychain (may be created with keychains.create)'},
          {'xpub' => 'xPub of backup keychain'},
          {'xpub' => 'xPub of BitGo keychain (created with keychains.createBitGo)'},
        ],
      }
    end

    before do
      allow(session).to receive(:call) { get_fixture('wallet.json') }
    end

    it 'adds wallet' do
      wallet = Bitgo::Wallet.add(session, params)
      expect(wallet).to have_key('id')
    end
  end
end

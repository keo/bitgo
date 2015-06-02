require 'spec_helper'

describe Bitgo::Wallet do
  let(:session) { double(:session) }
  let(:wallet) { Bitgo::Wallet.new(session, data) }

  describe '#initialize' do
    let(:data) do
      get_fixture('wallet.json')
    end

    it 'set default data' do
      wallet = Bitgo::Wallet.new(session)
      expect(wallet.id).to be_nil
    end

    it 'sets data' do
      expect(wallet.id).to eq "2MsajnHwkzQvggkb6Zbi7kaLMcpeCko4BKB"
      expect(wallet.label).to eq "My Test Wallet"
      expect(wallet.is_active).to eq true
    end
  end

  describe '#permissions' do
    let(:data) { { 'permissions' => 'admin,spend,view' } }

    it 'defaults to empty array' do
      wallet = Bitgo::Wallet.new(session)
      expect(wallet.permissions).to eq []
    end

    it 'sets permissions' do
      expect(wallet.permissions).to match_array ['admin', 'spend', 'view']
    end
  end

  describe '#balance' do
    let(:data) { { 'balance' => 1 } }

    it 'sets default balance' do
      wallet = Bitgo::Wallet.new(session)
      expect(wallet.balance).to be_nil
    end

    it 'sets the balance' do
      expect(wallet.balance).to eq 1
    end
  end

  describe '#confirmed_balance' do
    let(:data) { { 'confirmedBalance' => 100 } }

    it 'sets default confirmed balance' do
      wallet = Bitgo::Wallet.new(session)
      expect(wallet.confirmed_balance).to be_nil
    end

    it 'sets value' do
      expect(wallet.confirmed_balance).to eq 100
    end
  end

  describe '#spending_account' do
    let(:data) { { 'spendingAccount' => true } }

    it 'sets default spending account' do
      expect(Bitgo::Wallet.new(session).spending_account).to be_nil
    end

    it 'sets spending account value' do
      expect(wallet.spending_account).to eq true
    end
  end

  describe '#pending_approvals' do
    it 'defaults to empty array' do
      expect(Bitgo::Wallet.new(session).pending_approvals).to eq []
    end
  end

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

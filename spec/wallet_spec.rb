require 'spec_helper'

describe Bitgo::Wallet do
  let(:token) { double(:token).as_null_object }
  let(:session) { double(:session) }
  let(:wallet) { Bitgo::Wallet.new(session, data) }

  describe '#initialize' do
    let(:data) do
      get_fixture('wallet.json')
    end

    it 'set default data' do
      wallet = Bitgo::Wallet.new(token)
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
      wallet = Bitgo::Wallet.new(token)
      expect(wallet.permissions).to eq []
    end

    it 'sets permissions' do
      expect(wallet.permissions).to match_array ['admin', 'spend', 'view']
    end
  end

  describe '#balance' do
    let(:data) { { 'balance' => 1 } }

    it 'sets default balance' do
      wallet = Bitgo::Wallet.new(token)
      expect(wallet.balance).to be_nil
    end

    it 'sets the balance' do
      expect(wallet.balance).to eq 1
    end
  end

  describe '#confirmed_balance' do
    let(:data) { { 'confirmedBalance' => 100 } }

    it 'sets default confirmed balance' do
      wallet = Bitgo::Wallet.new(token)
      expect(wallet.confirmed_balance).to be_nil
    end

    it 'sets value' do
      expect(wallet.confirmed_balance).to eq 100
    end
  end

  describe '#spending_account' do
    let(:data) { { 'spendingAccount' => true } }

    it 'sets default spending account' do
      expect(Bitgo::Wallet.new(token).spending_account).to be_nil
    end

    it 'sets spending account value' do
      expect(wallet.spending_account).to eq true
    end
  end

  describe '#pending_approvals' do
    it 'defaults to empty array' do
      expect(Bitgo::Wallet.new(token).pending_approvals).to eq []
    end
  end

  describe '.get' do
    let(:raw_data) { get_fixture('wallet.json') }

    before do
      stub_request(:get, 'https://test.bitgo.com/api/v1/wallet/walletid123123').
        to_return(body: raw_data.to_json, status: 200)
    end

    it 'returns wallet' do
      wallet = Bitgo::Wallet.get(token, 'walletid123123')
      expect(wallet).to be_instance_of Bitgo::Wallet
    end

    it 'sets data from raw_data' do
      wallet = Bitgo::Wallet.get(token, 'walletid123123')
      expect(wallet.id).to eq raw_data['id']
    end
  end

  describe '.list' do
    before do
      stub_request(:get, "https://test.bitgo.com/api/v1/wallet").
        to_return(body: get_fixture('wallets.json').to_json)
    end

    it 'returns list of wallets' do
      wallets = Bitgo::Wallet.list(token)
      expect(wallets.first).to be_instance_of Bitgo::Wallet
    end
  end

  describe '.add' do
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
      stub_request(:post, 'https://test.bitgo.com/api/v1/wallet').
        to_return(body: get_fixture('wallet.json').to_json)
    end

    it 'adds wallet' do
      wallet = Bitgo::Wallet.add(token, params)
      expect(wallet).to be_instance_of Bitgo::Wallet
    end
  end
end

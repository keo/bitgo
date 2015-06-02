require 'spec_helper'

describe Bitgo::Wallet do
  let(:session) { double(:session) }

  describe '#list' do
    before do
      allow(session).to receive(:call) { get_fixture('wallets.json') }
    end

    it 'returns list of wallets' do
      wallet = Bitgo::Wallet.new(session)
      expect(wallet.list).to have_key('wallets')
    end
  end

  describe '#create' do
    it 'creates wallet' do
      wallet = Bitgo::Wallet.new(session)
    end
  end
end

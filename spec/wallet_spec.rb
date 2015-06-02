require 'spec_helper'

describe Bitgo::Wallet do
  let(:session) { double(:session) }

  describe '#create' do
    it 'creates wallet' do
      wallet = Bitgo::Wallet.new(session)
    end
  end
end

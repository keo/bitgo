require 'spec_helper'

describe Bitgo::Resource do
  let(:session) { double(:session) }

  describe '.attribute' do
    before do
      class TestResource < Bitgo::Resource
        attribute('foo')
        attribute(:bar)
        attribute(:encrypted_xpub)
      end
    end

    it 'sets attributes' do
      resource = TestResource.new(session, 'foo' => 1)
      expect(resource.foo).to eq 1
    end

    it 'converts symbol attribute into string' do
      resource = TestResource.new(session, 'bar' => 'yay')
      expect(resource.bar).to eq 'yay'
    end

    it 'converts camel-case attribute into underscore' do
      resource = TestResource.new(session, 'encryptedXpub' => 'aaa')
      expect(resource.encrypted_xpub).to eq 'aaa'
    end

    it 'sets a value' do
      resource = TestResource.new(session)
      resource.encrypted_xpub = 'bbbb'
      expect(resource.encrypted_xpub).to eq 'bbbb'
    end

    it 'resets the value' do
      resource = TestResource.new(session, 'encryptedXpub' => 'aaaa')
      resource.encrypted_xpub = 'bbbb'
      expect(resource.encrypted_xpub).to eq 'bbbb'
    end
  end
end

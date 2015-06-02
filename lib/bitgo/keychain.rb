module Bitgo
  class Keychain
    attr_accessor :session

    def initialize(session)
      @session = session
    end

    def all
      request = Net::HTTP::Get.new('/api/v1/keychain')
      session.call(request)
    end

    # = Create Keychain
    #
    # Returns an object containing the xprv and xpub for the new chain. The
    # created keychain is not known to the BitGo service. To use it with the
    # BitGo service, use the Keychains.Add API.
    #
    # For security reasons, it is highly recommended that you encrypt and
    # destroy the original xprv immediately to prevent theft.
    #
    # == Parameters
    # * <tt>xpub</tt> - The BIP32 kpub for this keychain
    # * <tt>encryptedXprv</tt> - the encrypted, BIP32 xprv for this keychain
    #
    def create(params)
      xpub = params.fetch('xpub')
      encryptedXprv = params.fetch('encryptedXprv')
      request = Net::HTTP::Post.new('/api/v1/keychain')
      request.body = { 'xpub' => xpub, 'encryptedXprv' => encryptedXprv }
      session.call(request)
    end

    def create_bitgo
      request = Net::HTTP::Post.new('/api/v1/keychain/bitgo')
      session.call(request)
    end

    def get(xpub)
      request = Net::HTTP::Post.new("/api/v1/keychain/#{xpub}")
      session.call(request)
    end

    def update(params)
      xpub = params.fetch("xpub")
      encryptedXprv = params.fetch("encryptedXprv")
      request = Net::HTTP::Put.new("/api/v1/keychain/#{xpub}")
      request.body = { "encryptedXprv" => encryptedXprv }.to_json
      session.call(request)
    end

    def self.create(session, params)
      new(session).create(params)
    end

    def self.create_bitgo(session, params)
      new(session).create_bitgo(params)
    end
  end
end

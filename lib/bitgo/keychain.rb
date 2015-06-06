module Bitgo
  class Keychain < Resource
    attribute(:xpub)
    attribute(:path)
    attribute(:xprv)
    attribute(:encrypted_xprv)
    attribute(:is_bitgo)

    def bitgo?
      is_bitgo
    end

    # = Update Keychain
    #
    # Update a keychain. This is used if you wish to store a new version of the
    # xprv (for example, if you changed the password used to encrypt the xprv).
    def update(params)
      encryptedXprv = params.fetch("encryptedXprv")
      request       = Net::HTTP::Put.new("/api/v1/keychain/#{xpub}")
      request.body  = { "encryptedXprv" => encryptedXprv }.to_json
      raw_data = session.call(request)

      # TODO: Redundant from #initialize
      self.xpub           = raw_data['xpub']
      self.is_bitgo       = raw_data['isBitgo']
      self.path           = raw_data['path']
      self.xprv           = raw_data['xprv']
      self.encrypted_xprv = raw_data['encryptedXprv']
    end

    # = List Keychains
    #
    # Get the list of public keychains for the user
    def self.list(session)
      request  = Net::HTTP::Get.new('/api/v1/keychain')
      raw_data = session.call(request)
      raw_data['keychains'].map{ |keychain| new(session, keychain) }
    end

    # = Get Keychain
    #
    # Lookup a keychain by xpub
    #
    # NOTE: This operation requires the session to be unlocked using the Unlock
    # API.
    def self.get(session, xpub)
      request  = Net::HTTP::Post.new("/api/v1/keychain/#{xpub}")
      raw_data = session.call(request)

      handle_errors(session.raw_response)
      new(session, raw_data)
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
    def self.create(session, params)
      xpub          = params.fetch('xpub')
      encryptedXprv = params.fetch('encryptedXprv')
      request       = Net::HTTP::Post.new('/api/v1/keychain')
      request.body  = { 'xpub' => xpub, 'encryptedXprv' => encryptedXprv }.to_json
      raw_data      = session.call(request)

      # TODO: Handle errors
      new(session, raw_data)
    end

    # = Create Bitgo Keychain
    #
    # Creates a new keychain on BitGo’s servers and returns the public keychain
    # to the caller.
    def self.create_bitgo(session)
      request  = Net::HTTP::Post.new('/api/v1/keychain/bitgo')
      raw_data = session.call(request)

      new(session, raw_data)
    end

    private

    def self.handle_errors(raw_response)
      if raw_response.code == '401'
        raise Bitgo::NeedsUnlockError
      end
    end
  end
end

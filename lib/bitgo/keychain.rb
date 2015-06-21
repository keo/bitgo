module Bitgo
  class Keychain < Resource
    attributes(:xpub, :path, :xprv, :encrypted_xprv, :is_bitgo)

    def bitgo?
      is_bitgo
    end

    # = Update Keychain
    #
    # Update a keychain. This is used if you wish to store a new version of the
    # xprv (for example, if you changed the password used to encrypt the xprv).
    def update(params)
      encryptedXprv = params.fetch("encryptedXprv")
      body  = { "encryptedXprv" => encryptedXprv }.to_json
      raw_data = HTTP.new(token).put("/api/v1/keychain/#{xpub}", body)

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
    def self.list(token)
      raw_data = HTTP.new(token).get('/api/v1/keychain')
      raw_data['keychains'].map{ |keychain| new(token, keychain) }
    end

    # = Get Keychain
    #
    # Lookup a keychain by xpub
    #
    # NOTE: This operation requires the session to be unlocked using the Unlock
    # API.
    def self.get(token, xpub)
      http = HTTP.new(token)
      raw_data = http.post("/api/v1/keychain/#{xpub}")

      handle_errors(http.raw_response)
      new(token, raw_data)
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
    def self.create(token, params)
      xpub          = params.fetch('xpub')
      encryptedXprv = params.fetch('encryptedXprv')
      body  = { 'xpub' => xpub, 'encryptedXprv' => encryptedXprv }.to_json
      raw_data = HTTP.new(token).post("/api/v1/keychain", body)

      # TODO: Handle errors
      new(token, raw_data)
    end

    # = Create Bitgo Keychain
    #
    # Creates a new keychain on BitGo’s servers and returns the public keychain
    # to the caller.
    def self.create_bitgo(token)
      raw_data = HTTP.new(token).post('/api/v1/keychain/bitgo')

      new(token, raw_data)
    end

    private

    def self.handle_errors(raw_response)
      if raw_response.code == '401'
        raise Bitgo::NeedsUnlockError
      end
    end
  end
end

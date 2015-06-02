module Bitgo
  class Wallet
    attr_accessor :session

    def initialize(session)
      @session = session
    end

    def all
      request = Net::HTTP::Get.new('/api/v1/wallet')
      session.call(request)
    end

    def create(params)

    end

    # params:
    #   label: a label for this wallet
    #   m: the number of signatures required to redeem (must be 2)
    #   n: number for keys in this wallet (must be 3)
    #   keychains: an array of n keychain xpubs to use with this wallet;
    #              last must be a Bitgo key
    #   enterprise: Enterprise ID to create this wallet under.
    def self.create(session, params)

    end
  end
end

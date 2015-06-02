module Bitgo
  class Wallet
    attr_accessor :session, :id, :label, :is_active, :type, :private,
      :permissions, :admin, :users, :spending_account, :confirmed_balance,
      :balance, :pending_approvals

    def initialize(session, raw_data={})
      @session           = session
      @id                = raw_data['id']
      @label             = raw_data['label']
      @is_active         = raw_data['isActive']
      @permissions       = raw_data['permissions']
      @balance           = raw_data['balance']
      @confirmed_balance = raw_data['confirmedBalance']
      @spending_account  = raw_data['spendingAccount']
      @pending_approvals = raw_data['pendingApprovals']
    end

    def permissions
      return [] if @permissions.nil?
      @permissions.split(',')
    end

    def pending_approvals
      @pending_approvals || []
    end

    class << self
      def get(session, id)
        request = Net::HTTP::Get.new("/api/v1/wallet/#{id}")
        data = session.call(request)
        new(session, data)
      end

      def list(session)
        request = Net::HTTP::Get.new('/api/v1/wallet')
        raw_wallets = session.call(request)
        raw_wallets['wallets'].map{|wallet| Bitgo::Wallet.new(session, wallet)}
      end

      # = Add Wallet
      #
      # This API creates a new wallet for the user. The keychains to use with the
      # new wallet must be registered with BitGo prior to using this API.
      #
      # BitGo currently only supports 2-of-3 (e.g. m=2 and n=3) wallets. The
      # third keychain, and only the third keychain, must be a BitGo key. The
      # first keychain is by convention the user key, with it’s encrypted xpriv
      # is stored on BitGo.
      #
      # BitGo wallets currently are hard-coded with their root at m/0/0 across
      # all 3 keychains (however, older legacy wallets may use different key
      # paths). Below the root, the wallet supports two chains of addresses, 0
      # and 1. The 0-chain is for external receiving addresses, while the 1-chain
      # is for internal (change) addresses.
      #
      # The first receiving address of a wallet is at the BIP32 path m/0/0/0/0,
      # which is also the ID used to refer to a wallet in BitGo’s system. The
      # first change address of a wallet is at m/0/0/1/0.
      #
      # == Parameters
      #
      # * <tt>label</tt> - a label for this wallet
      # * <tt>m</tt> - the number of signatures required to redeem (must be 2)
      # * <tt>n</tt>: number for keys in this wallet (must be 3)
      # * <tt>keychains</tt> - an array of n keychain xpubs to use with this
      #                        wallet; last must be a Bitgo key
      # * <tt>enterprise</tt> - Enterprise ID to create this wallet under.
      #
      def add(session, params)
        label      = params.fetch('label')
        m          = params.fetch('m')
        n          = params.fetch('n')
        keychains  = params.fetch('keychains')
        enterprise = params.fetch('enterprise') { nil }

        request = Net::HTTP::Post.new('/api/v1/wallet')
        request.body = { 'label'      => label,
                         'm'          => m,
                         'n'          => n,
                         'keychains'  => keychains,
                         'enterprise' => enterprise }.to_json
        raw_data = session.call(request)

        Bitgo::Wallet.new(session, raw_data)
      end
    end
  end
end

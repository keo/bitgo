require 'net/http'

module Bitgo
  class AccessToken
    attr_accessor :access_token, :expires_in, :token_type

    def initialize(options)
      @access_token = options.fetch('access_token')
      @expires_in   = options.fetch('expires_in')
      @token_type   = options.fetch('token_type')
      @user         = options.fetch('user')
    end

    def user
      Bitgo::User.new(self, @user)
    end
  end
end

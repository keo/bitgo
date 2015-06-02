require "json"
require "net/http"
require "bitgo/version"
require "bitgo/session"
require "bitgo/user"
require "bitgo/keychain"
require "bitgo/wallet"

module Bitgo

  extend self

  ACCESS_TOKEN = "ABC123"

  PROD = "https://www.bitgo.com/"
  TEST = "https://test.bitgo.com/"

  def session
    Session.new(access_token: ACCESS_TOKEN)
  end

  def keychain
    Keychain.new(session)
  end

  def user
    User.new(session)
  end

  def wallet
    Wallet.new(session)
  end
end

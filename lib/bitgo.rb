require "json"
require "net/http"
require "bitgo/version"
require "bitgo/auth"
require "bitgo/session"
require "bitgo/user"
require "bitgo/keychain"
require "bitgo/wallet"

module Bitgo

  extend self

  ACCESS_TOKEN = "ABC123"

  PROD = "https://www.bitgo.com/"
  TEST = "https://test.bitgo.com/"

  def base_uri
    if ENV['ENV'] == :production
      URI("#{Bitgo::PROD}")
    else
      URI("#{Bitgo::TEST}")
    end
  end
end

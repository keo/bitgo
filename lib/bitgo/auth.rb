require 'openssl'

module Bitgo
  class Auth
    attr_accessor :email, :password, :otp, :digest

    def initialize(options)
      @email    = options.fetch('email')
      @password = options.fetch('password')
      @otp      = options.fetch('otp')

      @digest   = OpenSSL::Digest.new('sha256')
    end

    def call
      http = Net::HTTP.new(base_uri.host, base_uri.port)
      http.use_ssl = true

      request = Net::HTTP::Post.new('/api/v1/users/login')
      request.body = { 'email'    => email,
                       'password' => encrypted_password,
                       'otp'      => otp }.to_json
      response = http.request(request)

      Bitgo::Session.new(response)
    end

    def encrypted_password
      hmac = OpenSSL::HMAC.new(email, digest)
      hmac.update(password).to_s
    end

    def base_uri
      Bitgo.base_uri
    end
  end
end

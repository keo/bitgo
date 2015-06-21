require 'openssl'

module Bitgo
  class Auth
    BadRequestError = Class.new(StandardError)
    UnauthorizedError = Class.new(StandardError)

    attr_accessor :email, :password, :otp, :digest, :response

    def initialize(options)
      @email    = options.fetch('email')
      @password = options.fetch('password')
      @otp      = options.fetch('otp')

      @digest   = OpenSSL::Digest.new('sha256')
    end

    def call
      http = HTTP.new
      request = Net::HTTP::Post.new('/api/v1/user/login')
      request.body = { 'email'    => email,
                       'password' => encrypted_password,
                       'otp'      => otp }.to_json

      response = http.call(request)
      handle_error(http.raw_response)

      # TODO: Handle errors
      token = AccessToken.new(response)
      Session.get(token)
    end

    def encrypted_password
      hmac = OpenSSL::HMAC.new(email, digest)
      hmac.update(password).to_s
    end

    def base_uri
      Bitgo.base_uri
    end

    private

    def handle_error(response)
      case response.code
      when '400'
        raise BadRequestError.new
      when '401'
        raise UnauthorizedError.new
      end
    end
  end
end

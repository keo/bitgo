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
      http = Net::HTTP.new(base_uri.host, base_uri.port)
      http.use_ssl = true

      request = Net::HTTP::Post.new('/api/v1/user/login')
      request.add_field('Content-type', 'application/json')
      request.body = { 'email'    => email,
                       'password' => encrypted_password,
                       'otp'      => otp }.to_json
      raw_response = http.request(request)
      response = JSON.parse(raw_response.body)

      handle_error(raw_response)

      # TODO: Handle errors
      Session.new(response)
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

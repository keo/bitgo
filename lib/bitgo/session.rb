require 'net/http'

module Bitgo
  class Session
    attr_accessor :access_token, :raw_response, :env, :expires_in, :token_type

    def initialize(options)
      @access_token = options.fetch('access_token')
      @expires_in   = options.fetch('expires_in')
      @token_type   = options.fetch('token_type')
      @user         = options.fetch('user')
      @env          = options.fetch('env', :test)
    end

    def user
      Bitgo::User.new(self, @user)
    end

    def call(request)
      http = Net::HTTP.new(base_uri.host, base_uri.port)
      http.use_ssl = true

      request.add_field("Authorization", "Bearer #{access_token}")

      response = http.request(request)

      @raw_response = response
      JSON.parse(response.body)
    rescue JSON::ParserError
      response.body
    end

    def base_uri
      ::Bitgo.base_uri
    end
  end
end

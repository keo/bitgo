require 'net/http'

module Bitgo
  class Session
    attr_accessor :access_token, :raw_response, :env

    def initialize(options, env=:test)
      @access_token = options.fetch(:access_token)
      @env = env
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
      if env == :prod
        URI("#{Bitgo::PROD}")
      else
        URI("#{Bitgo::TEST}")
      end
    end

    def keychains
      Bitgo::Keychains.new(self)
    end
  end
end

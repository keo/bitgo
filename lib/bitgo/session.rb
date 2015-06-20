module Bitgo
  class Session < Resource
    attr_accessor :token

    attributes(:client, :user, :expires, :origin, :scope)

    def initialize(token, raw_data={})
      super(token, raw_data)
      @token = token
    end

    def sendotp(params={})
      request = Net::HTTP::Post.new('/api/v1/user/sendotp')
      call(request)
    end

    def unlock(params)
      otp      = params.fetch('otp')
      duration = params.fetch('duration', 600)

      request = Net::HTTP::Post.new('/api/v1/user/unlock')
      request.add_field('Content-type', 'application/json')
      request.body = { 'otp' => otp, 'duration' => duration }.to_json

      call(request)
      self
    end

    def lock
      request = Net::HTTP::Post.new('/api/v1/user/lock')

      call(request)
    end

    def call(request)
      http = Net::HTTP.new(base_uri.host, base_uri.port)
      http.use_ssl = true

      request.add_field("Authorization", "Bearer #{token.access_token}")

      response = http.request(request)

      @raw_response = response
      JSON.parse(response.body)
    rescue JSON::ParserError
      response.body
    end

    def base_uri
      ::Bitgo.base_uri
    end

    # Instatiate session from a given token
    def self.get(token)
      request = Net::HTTP::Get.new('/api/v1/user/session')
      raw_data = new(token).call(request)
      new(token, raw_data['session'])
    end
  end
end

module Bitgo
  class HTTP
    attr_accessor :token, :raw_response

    METHODS = {
      get:    Net::HTTP::Get,
      post:   Net::HTTP::Post,
      put:    Net::HTTP::Put,
      delete: Net::HTTP::Delete
    }

    def initialize(token=nil)
      @token = token
    end

    METHODS.each do |m, klass|
      define_method m do |path, body=''|
        request = klass.new(path)
        request.body = body
        call(request)
      end
    end

    def call(request)
      http = Net::HTTP.new(base_uri.host, base_uri.port)
      http.use_ssl = true

      if token
        request.add_field("Authorization", "Bearer #{token.access_token}")
      end
      request.add_field('Content-type', 'application/json')

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

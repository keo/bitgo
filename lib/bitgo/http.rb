module Bitgo
  class HTTP
    attr_accessor :token, :raw_response

    def initialize(token=nil)
      @token = token
    end

    def get(path, body='')
      request      = Net::HTTP::Get.new(path)
      request.body = body
      call(request)
    end

    def post(path, body='')
      request      = Net::HTTP::Post.new(path)
      request.body = body
      call(request)
    end

    def put(path, body='')
      request      = Net::HTTP::Put.new(path)
      request.body = body
      call(request)
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

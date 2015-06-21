module Bitgo
  class Session < Resource
    attr_accessor :token, :raw_response

    attributes(:client, :user, :expires, :origin, :scope, :unlock)

    def sendotp(params={})
      HTTP.new(token).post('/api/v1/user/sendotp')
    end

    def unlock(params)
      otp      = params.fetch('otp')
      duration = params.fetch('duration', 600)

      body = { 'otp' => otp, 'duration' => duration }.to_json
      raw_token = HTTP.new(token).post('/api/v1/user/unlock', body)

      update_attributes(raw_token)
      self
    end

    def lock
      HTTP.new(token).post('/api/v1/user/lock')
    end

    # Instatiate session from a given token
    def self.get(token)
      raw_data = HTTP.new(token).get('/api/v1/user/session')
      new(token, raw_data['session'])
    end
  end
end

module Bitgo
  class User < Resource
    attr_accessor :first_name, :last_name, :full_name

    attributes(:id, :username, :is_active)

    def initialize(token, raw_data={})
      super(token, raw_data)
      name           = raw_data['name'] || {}
      @first_name    = name['first']
      @last_name     = name['last']
      @full_name     = name['full']
    end

    def active?
      is_active
    end

    def self.me!(token)
      raw_data = HTTP.new(token).get('/api/v1/user/me')
      new(token, raw_data['user'])
    end
  end
end

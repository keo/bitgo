module Bitgo
  class User
    attr_accessor :session, :id, :first_name, :last_name, :full_name, :username

    def initialize(session, raw_data={})
      @session = session
      @id            = raw_data['id']
      name           = raw_data['name'] || {}
      @first_name    = name['first']
      @last_name     = name['last']
      @full_name     = name['full']
      @username      = raw_data['username']
      @isActive      = raw_data['isActive']
    end

    def active?
      @isActive
    end

    def self.me(session)
      request = Net::HTTP::Get.new('/api/v1/user/me')
      raw_data = session.call(request)

      new(session, raw_data)
    end
  end
end

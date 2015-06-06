module Bitgo
  class User < Resource
    attr_accessor :first_name, :last_name, :full_name

    attribute(:id)
    attribute(:username)
    attribute(:is_active)

    def initialize(session, raw_data={})
      super(session, raw_data)
      name           = raw_data['name'] || {}
      @first_name    = name['first']
      @last_name     = name['last']
      @full_name     = name['full']
    end

    def active?
      is_active
    end

    def self.me(session)
      request = Net::HTTP::Get.new('/api/v1/user/me')
      raw_data = session.call(request)

      new(session, raw_data)
    end
  end
end

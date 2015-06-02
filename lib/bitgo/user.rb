module Bitgo
  class User
    attr_accessor :session

    def initialize(session)
      @session = session
    end

    def me
      request = Net::HTTP::Get.new('/api/v1/user/me')
      session.call(request)
    end
  end
end

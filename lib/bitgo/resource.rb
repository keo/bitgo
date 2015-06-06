module Bitgo
  class Resource
    def self.attribute(attr)
      define_method attr do
        normalized_attr = attr.to_s.camelize(:lower)
        @data[attr] = @data[attr] || @raw_data[attr.to_s.camelize(:lower)]
        @data[attr]
      end

      define_method "#{attr}=" do |val|
        @data[attr] = val
      end
    end

    attr_accessor :session, :data

    def initialize(session, raw_data={})
      @session = session
      @raw_data = raw_data
      @data = ActiveSupport::HashWithIndifferentAccess.new
    end
  end
end

module Bitgo
  class Resource
    @@attributes ||= []

    def self.attribute(attr)
      @@attributes << attr

      define_method attr do
        normalized_attr = attr.to_s.camelize(:lower)
        @data[attr] = @data[attr] || @raw_data[attr.to_s.camelize(:lower)]
        @data[attr]
      end

      define_method "#{attr}=" do |val|
        @data[attr] = val
      end
    end

    def self.attributes(*attrs)
      attrs.each do |attr|
        self.attribute(attr)
      end
    end

    attr_accessor :session, :data

    def initialize(session, raw_data={})
      @session = session
      @raw_data = raw_data
      @data = ActiveSupport::HashWithIndifferentAccess.new
    end

    def update_attributes(attrs={})
      attrs.each do |k, v|
        key = k.to_s
        self.send("#{key}=", v) if @@attributes.include?(key)
      end
    end
  end
end

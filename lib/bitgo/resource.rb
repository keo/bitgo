module Bitgo
  class Resource
    @@attributes ||= []

    def self.attribute(attr)
      @@attributes << attr
      attr_accessor attr
    end

    def self.attributes(*attrs)
      attrs.each do |attr|
        self.attribute(attr)
      end
    end

    attr_accessor :token

    def initialize(token, raw_data={})
      @token    = token
      @raw_data = raw_data || {}
      assign_raw_data_to_instance_variable
    end

    def update_attributes(attrs={})
      attrs.each do |attr, val|
        send("#{attr}=", val)
      end
    end

    private

    def assign_raw_data_to_instance_variable
      @raw_data.each do |attr, val|
        instance_variable_set("@#{attr.underscore}", val)
      end
    end
  end
end

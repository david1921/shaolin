module Encryption
  module AttrEncrypted
    def self.included(base)
      raise "Global attr_encrypted default key has not been set" unless default_options[:key].present?
      base.attr_encrypted_options.merge! key: default_options[:key]
    end

    def self.default_options
      @default_options ||= {}
    end
  end
end

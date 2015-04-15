require 'yeepay/version'
require 'yeepay/service'
require 'yeepay/service/card'

module Yeepay
  class << self
    attr_accessor :p1_mer_id
    attr_accessor :merchant_key
    attr_writer :debug_mode

    def debug_mode?
      @debug_mode.nil? ? true : !!@debug_mode
    end
  end
end


# frozen_string_literal: true
module Ferver
  class FileIdRequest
    attr_reader :value

    def initialize(value = nil)
      @is_valid = false

      self.value = value
    end

    def value=(value)
      @value = parse_value(value)
    end

    def valid?
      @is_valid
    end

    private

    def parse_value(value)
      int_val = Integer(value)
      @is_valid = true
      int_val
    rescue
      @is_valid = false
    end
  end
end

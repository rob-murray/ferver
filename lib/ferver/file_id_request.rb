
module Ferver
  class FileIdRequest
    attr_reader :value

    def initialize(value = nil)
      @is_valid = false

      self.value = value
    end

    def value=(value)
      id = parse_value(value)

      @value = id
    end

    def valid?
      @is_valid
    end

    private

    def parse_value(value)
      begin
        int_val = Integer(value)
        @is_valid = true
        int_val
      rescue
        @is_valid = false
      end
    end
  end
end

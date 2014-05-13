
module Ferver
  class FileIdRequest
    attr_reader :value

    def initialize(value = nil)
      @is_valid = false

      self.value = value
    end

    def value=(value)
      id = parse_value(value)

      if id.nil?
        @is_valid = false
      else
        @value = id
        @is_valid = true
      end
    end

    def valid?
      @is_valid
    end

    private

    def parse_value(value)
      begin
        Integer(value)
      rescue
        nil
      end
    end
  end
end

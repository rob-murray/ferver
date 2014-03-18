
module Ferver
    class FileIdRequest

        attr_reader :value

        def initialize(value = nil)
            @is_valid = false

            self.value = value
        end

        def value=(value)
            id = Integer(value) rescue nil

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
    end
end
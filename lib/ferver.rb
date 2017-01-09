# frozen_string_literal: true
require_relative "ferver/configuration"
require_relative "ferver/errors"
require_relative "ferver/app"
require_relative "ferver/controller"
require_relative "ferver/ferver_directory"
require_relative "ferver/file_list"
require_relative "ferver/found_file"
require_relative "ferver/version"

module Ferver
  class << self
    attr_accessor :configuration

    def configuration
      @configuration ||= Configuration.new
    end

    def reset
      @configuration = Configuration.new
    end

    def configure
      yield(configuration)
    end
  end
end

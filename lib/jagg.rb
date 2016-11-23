module JAGG
  class << self
    # Load the gem's dependencies
    #
    # @api private
    #
    def load!
      require 'argspec'
      require 'digest/md5'
      require 'httpclient'
      require 'json'
      require 'uri'

      require 'jagg/constants'
      require 'jagg/helpers/string'
      require 'jagg/gravatar'
      require 'jagg/gravatar/image'
      require 'jagg/gravatar/profile'
    end
  end
end

JAGG.load!

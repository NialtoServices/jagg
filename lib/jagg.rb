# JAGG is a Gravatar API client that supports both images and profiles.
#
# @example Get the URL for an email address
#   JAGG::Gravatar::Image.url('user@example.com') #=> "https://www.gravatar.com/avatar/b58996c504c5638798eb6b511e6f49af"
# @example Fetch a user's profile
#   JAGG::Gravatar::Profile.for('user@example.com') #=> #<JAGG::Gravatar::Profile:0x00000000000000 ...>
#
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

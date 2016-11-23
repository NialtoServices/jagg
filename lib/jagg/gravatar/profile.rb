module JAGG
  class Gravatar
    # This class is responsible for fetching and parsing a user's profile.
    #
    class Profile
      class << self
        include ArgumentSpecification::DSL

        # Get the Gravatar profile URL for an email.
        #
        # @param email [String] The user's email address.
        # @param format [Symbol] The format to render the profile in.
        # @return [String] The URL to the gravatar profile.
        # @example HTML Format (default)
        #   JAGG::Gravatar::Profile.url('user@example.com') #=> "https://www.gravatar.com/b58996c504c5638798eb6b511e6f49af"
        # @example JSON Format
        #   JAGG::Gravatar::Profile.url('user@example.com', :json) #=> "https://www.gravatar.com/b58996c504c5638798eb6b511e6f49af.json"
        # @example XML Format
        #   JAGG::Gravatar::Profile.url('user@example.com', :xml) #=> "https://www.gravatar.com/b58996c504c5638798eb6b511e6f49af.xml"
        #
        def url(email, format = nil)
          argument(email) { should be_a(String) }
          argument(format) { should be_one_of(:json, :xml) } if format

          uri = URI.parse('https://www.gravatar.com/')
          uri.path = '/' + email.to_md5
          uri.path += '.' + format.to_s if format
          uri.to_s
        end

        # Get a Gravatar profile object for an email.
        #
        # @param email [String] The user's email address.
        # @return [JAGG::Gravatar::Profile] A gravatar profile object.
        # @example
        #   JAGG::Gravatar::Profile.for('user@example.com') #=> #<JAGG::Gravatar::Profile:0x00000000000000 ...>
        #
        def for(email)
          response = Gravatar.http_client.get(url(email, :json), follow_redirect: true)

          return nil unless response.ok?
          return nil unless response = JSON.parse(response.body)
          return nil unless response = response['entry'][0] rescue nil

          new(response)
        end
      end

      # The user's gravatar identifier.
      #
      attr_reader :gravatar_id

      # The user's first name.
      #
      attr_reader :first_name

      # The user's last name.
      #
      attr_reader :last_name

      # The user's formatted name (usually full name).
      #
      attr_reader :formatted_name

      # The user's display name.
      #
      attr_reader :display_name

      # The user's preferred username.
      #
      attr_reader :preferred_username

      # The user's thumbnail image.
      #
      attr_reader :thumbnail

      # An array of the user's images.
      #
      attr_reader :images

      private
      # Create a new profile instance
      #
      # @param raw [Hash] A hash containins raw profile data.
      # @example
      #   Profile.new(raw) #=> #<JAGG::Gravatar::Profile:0x00000000000000 ...>
      #
      def initialize(raw)
        @gravatar_id = raw['id']

        if display_name = raw['displayName']
          @display_name = display_name
        end

        if preferred_username = raw['preferredUsername']
          @preferred_username = preferred_username
        end

        if thumbnail_url = raw['thumbnailUrl']
          @thumbnail = Gravatar::Image.new(thumbnail_url, :thumbnail)
        end

        if raw['photos'].is_a?(Array)
          @images = raw['photos'].map do |data|
            Gravatar::Image.new(data['value'], data['type'].to_sym)
          end
        else
          @images = []
        end

        if raw['name'].is_a?(Hash)
          if first_name = raw['name']['givenName']
            @first_name = first_name
          end

          if last_name = raw['name']['familyName']
            @last_name = last_name
          end

          if formatted_name = raw['name']['formatted']
            @formatted_name = formatted_name
          end
        end
      end
    end
  end
end

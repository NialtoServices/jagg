module JAGG
  class Gravatar
    # This class acts as a wrapper around an image URL.
    #
    class Image
      class << self
        include ArgumentSpecification::DSL

        # Get the Gravatar image URL for an email.
        #
        # @param email [String] The user's email address.
        # @param size [Integer] The size of the image (in pixels).
        # @return [String] The URL to the gravatar image.
        # @example Get a Thumbnail
        #   JAGG::Gravatar::Image.url('user@example.com') #=> "https://www.gravatar.com/avatar/b58996c504c5638798eb6b511e6f49af"
        # @example Get a custom size
        #   JAGG::Gravatar::Image.url('user@example.com', 256) #=> "https://www.gravatar.com/avatar/b58996c504c5638798eb6b511e6f49af?size=256"
        #
        def url(email, size = nil)
          argument(email) { should be_a(String) }
          argument(size) { should be_an(Integer) } if size

          uri = URI.parse('https://www.gravatar.com/')
          uri.path = '/avatar/' + email.to_md5
          uri.query = 'size=' + size.to_s if size
          uri.to_s
        end

        # Get a Gravatar image object for an email.
        #
        # @param email [String] The user's email address.
        # @return [JAGG::Gravatar::Image] A gravatar image object.
        # @example
        #   JAGG::Gravatar::Image.for('user@example.com') #=> #<JAGG::Gravatar::Image:0x00000000000000 ...>
        #
        def for(email)
          new(url(email))
        end
      end

      include ArgumentSpecification::DSL

      # The URL to the image.
      #
      attr_reader :url

      # The type/kind of image (optional).
      #
      attr_reader :kind

      # Create a new image object.
      #
      # @param url [String] The url to the image.
      # @param kind [Symbol] The type/kind of image.
      # @example
      #   JAGG::Gravatar::Image.new(url, kind) #=> #<JAGG::Gravatar::Image:0x00000000000000 ...>
      #
      def initialize(url, kind = nil)
        uri = URI.parse(url)
        uri.query = nil
        @url = uri.to_s
        @kind = kind
      end

      # Get the URL for the image at a specific size.
      #
      # @param size [Integer] The size of the image (in pixels).
      # @return [String] The URL of the image at the specified size.
      # @example
      #   image.url_of_size(256) #=> "https://www.gravatar.com/avatar/b58996c504c5638798eb6b511e6f49af?size=256"
      #
      def url_of_size(size)
        return nil unless @url

        argument(size) do
          should be_an(Integer)
          should be_within_range(1..2048)
        end

        uri = URI.parse(@url)
        uri.query = 'size=' + size.to_s
        uri.to_s
      end

      # Fetch the image data.
      #
      # @param size [Integer] The size of the image (in pixels).
      # @return [String] The raw image data.
      # @example
      #   image.fetch #=> "..."
      #
      def fetch(size = nil)
        return nil unless @url

        url = size ? url_of_size(size) : @url

        response = Gravatar.http_client.get(url, follow_redirect: true)

        return nil unless response.ok?

        response.body
      end
    end
  end
end

module JAGG
  # The Gravatar class (and it's namespaces) are used to convert the data from
  # Gravatar's API into objects.
  #
  class Gravatar
    class << self
      # Get the HTTP Client.
      #
      # @return [HTTPClient] A HTTPClient instance.
      # @example
      #   JAGG::Gravatar.http_client
      #
      def http_client
        return @client if @client

        @client = HTTPClient.new
        @client.redirect_uri_callback = Proc.new { |uri, result| result.header['location'][0] }
        @client
      end
    end
  end
end

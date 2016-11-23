class ::String
  # Convert the string into an MD5 hash
  #
  # @example
  #   "Hello, World!".to_md5 #=> "65a8e27d8879283831b664bd8b7f0ad4"
  #
  def to_md5
    Digest::MD5.hexdigest(self)
  end
end

module Mail
  module Encodings
    module UnixToUnix
      NAME = "x-uuencode"

      def self.decode(str)
        str.sub(/\Abegin \d+ [^\n]*\n/, '').unpack('u').first
      end

      def self.encode(str)
        [str].pack("u")
      end

      Encodings.register(NAME, self)
    end
  end
end

# encoding: utf-8
module Mail
  module Utilities
    include Constants

    # Returns true if the string supplied is free from characters not allowed as an ATOM
    def atom_safe?( str )
      not ATOM_UNSAFE === str
    end

    # If the string supplied has ATOM unsafe characters in it, will return the string quoted
    # in double quotes, otherwise returns the string unmodified
    def quote_atom( str )
      atom_safe?( str ) ? str : dquote(str)
    end

    # If the string supplied has PHRASE unsafe characters in it, will return the string quoted
    # in double quotes, otherwise returns the string unmodified
    def quote_phrase( str )
      if RUBY_VERSION >= '1.9'
        original_encoding = str.encoding
        str.force_encoding('ASCII-8BIT')
        if (PHRASE_UNSAFE === str)
          quoted_str = dquote(str).force_encoding(original_encoding)
          str.force_encoding(original_encoding)
          quoted_str
        else
          str.force_encoding(original_encoding)
        end
      else
        (PHRASE_UNSAFE === str) ? dquote(str) : str
      end
    end

    # Returns true if the string supplied is free from characters not allowed as a TOKEN
    def token_safe?( str )
      not TOKEN_UNSAFE === str
    end

    # If the string supplied has TOKEN unsafe characters in it, will return the string quoted
    # in double quotes, otherwise returns the string unmodified
    def quote_token( str )
      token_safe?( str ) ? str : dquote(str)
    end

    # Wraps supplied string in double quotes and applies \-escaping as necessary,
    # unless it is already wrapped.
    #
    # Example:
    #
    #  string = 'This is a string'
    #  dquote(string) #=> '"This is a string"'
    #
    #  string = 'This is "a string"'
    #  dquote(string #=> '"This is \"a string\"'
    def dquote( str )
      '"' + unquote(str).gsub(/[\\"]/n) {|s| '\\' + s } + '"'
    end

    # Unwraps supplied string from inside double quotes and
    # removes any \-escaping.
    #
    # Example:
    #
    #  string = '"This is a string"'
    #  unquote(string) #=> 'This is a string'
    #
    #  string = '"This is \"a string\""'
    #  unqoute(string) #=> 'This is "a string"'
    def unquote( str )
      if str =~ /^"(.*?)"$/
        $1.gsub(/\\(.)/, '\1')
      else
        str
      end
    end

    # Wraps a string in parenthesis and escapes any that are in the string itself.
    #
    # Example:
    #
    #  paren( 'This is a string' ) #=> '(This is a string)'
    def paren( str )
      RubyVer.paren( str )
    end

    # Unwraps a string from being wrapped in parenthesis
    #
    # Example:
    #
    #  str = '(This is a string)'
    #  unparen( str ) #=> 'This is a string'
    def unparen( str )
      match = str.match(/^\((.*?)\)$/)
      match ? match[1] : str
    end

    # Wraps a string in angle brackets and escapes any that are in the string itself
    #
    # Example:
    #
    #  bracket( 'This is a string' ) #=> '<This is a string>'
    def bracket( str )
      RubyVer.bracket( str )
    end

    # Unwraps a string from being wrapped in parenthesis
    #
    # Example:
    #
    #  str = '<This is a string>'
    #  unbracket( str ) #=> 'This is a string'
    def unbracket( str )
      match = str.match(/^\<(.*?)\>$/)
      match ? match[1] : str
    end

    # Escape parenthesies in a string
    #
    # Example:
    #
    #  str = 'This is (a) string'
    #  escape_paren( str ) #=> 'This is \(a\) string'
    def escape_paren( str )
      RubyVer.escape_paren( str )
    end

    def uri_escape( str )
      uri_parser.escape(str)
    end

    def uri_unescape( str )
      uri_parser.unescape(str)
    end

    def uri_parser
      @uri_parser ||= URI.const_defined?(:Parser) ? URI::Parser.new : URI
    end

    # Matches two objects with their to_s values case insensitively
    #
    # Example:
    #
    #  obj2 = "This_is_An_object"
    #  obj1 = :this_IS_an_object
    #  match_to_s( obj1, obj2 ) #=> true
    def match_to_s( obj1, obj2 )
      obj1.to_s.casecmp(obj2.to_s) == 0
    end

    # Capitalizes a string that is joined by hyphens correctly.
    #
    # Example:
    #
    #  string = 'resent-from-field'
    #  capitalize_field( string ) #=> 'Resent-From-Field'
    def capitalize_field( str )
      str.to_s.split("-").map { |v| v.capitalize }.join("-")
    end

    # Takes an underscored word and turns it into a class name
    #
    # Example:
    #
    #  constantize("hello") #=> "Hello"
    #  constantize("hello-there") #=> "HelloThere"
    #  constantize("hello-there-mate") #=> "HelloThereMate"
    def constantize( str )
      str.to_s.split(/[-_]/).map { |v| v.capitalize }.to_s
    end

    # Swaps out all underscores (_) for hyphens (-) good for stringing from symbols
    # a field name.
    #
    # Example:
    #
    #  string = :resent_from_field
    #  dasherize ( string ) #=> 'resent_from_field'
    def dasherize( str )
      str.to_s.tr(UNDERSCORE, HYPHEN)
    end

    # Swaps out all hyphens (-) for underscores (_) good for stringing to symbols
    # a field name.
    #
    # Example:
    #
    #  string = :resent_from_field
    #  underscoreize ( string ) #=> 'resent_from_field'
    def underscoreize( str )
      str.to_s.downcase.tr(HYPHEN, UNDERSCORE)
    end

    if RUBY_VERSION <= '1.8.6'

      def map_lines( str, &block )
        results = []
        str.each_line do |line|
          results << yield(line)
        end
        results
      end

      def map_with_index( enum, &block )
        results = []
        enum.each_with_index do |token, i|
          results[i] = yield(token, i)
        end
        results
      end

    else

      def map_lines( str, &block )
        str.each_line.map(&block)
      end

      def map_with_index( enum, &block )
        enum.each_with_index.map(&block)
      end

    end

  end
end

# encoding: utf-8

module Mail
  class Ruby18
    require 'base64'
    require 'iconv'

    # Escapes any parenthesis in a string that are unescaped. This can't
    # use the Ruby 1.9.1 regexp feature of negative look behind so we have
    # to do two replacement, first unescape everything, then re-escape it
    def Ruby18.escape_paren( str )
      re = /\\\)/
      str = str.gsub(re) { |s| ')'}
      re = /\\\(/
      str = str.gsub(re) { |s| '('}
      re = /([\(\)])/          # Only match unescaped parens
      str.gsub(re) { |s| '\\' + s }
    end

    def Ruby18.paren( str )
      str = $1 if str =~ /^\((.*)?\)$/
      str = escape_paren( str )
      '(' + str + ')'
    end

    def Ruby18.escape_bracket( str )
      re = /\\\>/
      str = str.gsub(re) { |s| '>'}
      re = /\\\</
      str = str.gsub(re) { |s| '<'}
      re = /([\<\>])/          # Only match unescaped parens
      str.gsub(re) { |s| '\\' + s }
    end

    def Ruby18.bracket( str )
      str = $1 if str =~ /^\<(.*)?\>$/
      str = escape_bracket( str )
      '<' + str + '>'
    end

    def Ruby18.decode_base64(str)
      Base64.decode64(str) if str
    end

    def Ruby18.encode_base64(str)
      Base64.encode64(str)
    end

    def Ruby18.has_constant?(klass, string)
      klass.constants.include?( string )
    end

    def Ruby18.get_constant(klass, string)
      klass.const_get( string )
    end

    def Ruby18.b_value_encode(str, encoding)
      # Ruby 1.8 requires an encoding to work
      raise ArgumentError, "Must supply an encoding" if encoding.nil?
      encoding = encoding.to_s.upcase.gsub('_', '-')
      [Encodings::Base64.encode(str), fix_encoding(encoding)]
    end

    def Ruby18.b_value_decode(str)
      match = str.match(/\=\?(.+)?\?[Bb]\?(.*)\?\=/m)
      if match
        encoding = match[1]
        str = Ruby18.decode_base64(match[2])
        str = Iconv.conv('UTF-8//IGNORE', fix_encoding(encoding), str)
      end
      str
    end

    def Ruby18.q_value_encode(str, encoding)
      # Ruby 1.8 requires an encoding to work
      raise ArgumentError, "Must supply an encoding" if encoding.nil?
      encoding = encoding.to_s.upcase.gsub('_', '-')
      [Encodings::QuotedPrintable.encode(str), encoding]
    end

    def Ruby18.q_value_decode(str)
      match = str.match(/\=\?(.+)?\?[Qq]\?(.*)\?\=/m)
      if match
        encoding = match[1]
        string = match[2].gsub(/_/, '=20')
        # Remove trailing = if it exists in a Q encoding
        string = string.sub(/\=$/, '')
        str = Encodings::QuotedPrintable.decode(string)
        str = Iconv.conv('UTF-8//IGNORE', fix_encoding(encoding), str)
      end
      str
    end

    def Ruby18.param_decode(str, encoding)
      URI.unescape(str)
    end

    def Ruby18.param_encode(str)
      encoding = $KCODE.to_s.downcase
      language = Configuration.instance.param_encode_language
      "#{encoding}'#{language}'#{URI.escape(str)}"
    end

    private

    def Ruby18.fix_encoding(encoding)
      case encoding.upcase
      when 'UTF8', 'UTF_8'
        'UTF-8'
      when 'UTF16', 'UTF-16'
        'UTF-16BE'
      when 'UTF32', 'UTF-32'
        'UTF-32BE'
      else
        encoding
      end
    end
  end
end

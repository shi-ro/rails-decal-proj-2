# encoding: utf-8
# 
# 
# 
module Mail
  class ContentTransferEncodingField < StructuredField
    
    FIELD_NAME = 'content-transfer-encoding'
    CAPITALIZED_FIELD = 'Content-Transfer-Encoding'
    
    def initialize(value = nil, charset = 'utf-8')
      self.charset = charset
      value = '7bit' if value.to_s =~ /7-?bits?/i
      value = '8bit' if value.to_s =~ /8-?bits?/i
      super(CAPITALIZED_FIELD, strip_field(FIELD_NAME, value), charset)
      self.parse
      self
    end
    
    def parse(val = value)
      unless val.blank?
        @element = Mail::ContentTransferEncodingElement.new(val)
      end
    end
    
    def element
      @element ||= Mail::ContentTransferEncodingElement.new(value)
    end
    
    def encoding
      element.encoding
    end
    
    # TODO: Fix this up
    def encoded
      "#{CAPITALIZED_FIELD}: #{encoding}\r\n"
    end
    
    def decoded
      encoding
    end
    
  end
end

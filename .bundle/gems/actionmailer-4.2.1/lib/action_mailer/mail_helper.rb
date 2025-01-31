module ActionMailer
  # Provides helper methods for ActionMailer::Base that can be used for easily
  # formatting messages, accessing mailer or message instances, and the
  # attachments list.
  module MailHelper
    # Take the text and format it, indented two spaces for each line, and
    # wrapped at 72 columns.
    def block_format(text)
      formatted = text.split(/\n\r?\n/).collect { |paragraph|
        format_paragraph(paragraph)
      }.join("\n\n")

      # Make list points stand on their own line
      formatted.gsub!(/[ ]*([*]+) ([^*]*)/) { "  #{$1} #{$2.strip}\n" }
      formatted.gsub!(/[ ]*([#]+) ([^#]*)/) { "  #{$1} #{$2.strip}\n" }

      formatted
    end

    # Access the mailer instance.
    def mailer
      @_controller
    end

    # Access the message instance.
    def message
      @_message
    end

    # Access the message attachments list.
    def attachments
      mailer.attachments
    end

    # Returns +text+ wrapped at +len+ columns and indented +indent+ spaces.
    #
    #   my_text = 'Here is a sample text with more than 40 characters'
    #
    #   format_paragraph(my_text, 25, 4)
    #   # => "    Here is a sample text with\n    more than 40 characters"
    def format_paragraph(text, len = 72, indent = 2)
      sentences = [[]]

      text.split.each do |word|
        if sentences.first.present? && (sentences.last + [word]).join(' ').length > len
          sentences << [word]
        else
          sentences.last << word
        end
      end

      indentation = " " * indent
      sentences.map! { |sentence|
        "#{indentation}#{sentence.join(' ')}"
      }.join "\n"
    end
  end
end

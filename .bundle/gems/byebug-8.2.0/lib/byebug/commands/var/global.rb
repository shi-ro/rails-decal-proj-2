module Byebug
  #
  # Reopens the +var+ command to define the +global+ subcommand
  #
  class VarCommand < Command
    #
    # Shows global variables
    #
    class GlobalCommand < Command
      include Helpers::VarHelper

      self.allow_in_post_mortem = true

      def self.regexp
        /^\s* g(?:lobal)? \s*$/x
      end

      def self.description
        <<-EOD
          v[ar] g[lobal]

          #{short_description}
        EOD
      end

      def self.short_description
        'Shows global variables.'
      end

      def execute
        var_global
      end
    end
  end
end

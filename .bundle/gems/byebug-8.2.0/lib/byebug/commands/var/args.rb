require 'byebug/helpers/var'

module Byebug
  #
  # Reopens the +var+ command to define the +args+ subcommand
  #
  class VarCommand < Command
    #
    # Information about arguments of the current method/block
    #
    class ArgsCommand < Command
      include Helpers::VarHelper

      self.allow_in_post_mortem = true

      def self.regexp
        /^\s* a(?:rgs)? \s*$/x
      end

      def self.description
        <<-EOD
          v[ar] a[args]

          #{short_description}
        EOD
      end

      def self.short_description
        'Information about arguments of the current scope'
      end

      def execute
        var_args
      end
    end
  end
end

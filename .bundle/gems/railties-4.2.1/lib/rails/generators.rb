activesupport_path = File.expand_path('../../../../activesupport/lib', __FILE__)
$:.unshift(activesupport_path) if File.directory?(activesupport_path) && !$:.include?(activesupport_path)

require 'thor/group'

require 'active_support'
require 'active_support/core_ext/object/blank'
require 'active_support/core_ext/kernel/singleton_class'
require 'active_support/core_ext/array/extract_options'
require 'active_support/core_ext/hash/deep_merge'
require 'active_support/core_ext/module/attribute_accessors'
require 'active_support/core_ext/string/inflections'

module Rails
  module Generators
    autoload :Actions,         'rails/generators/actions'
    autoload :ActiveModel,     'rails/generators/active_model'
    autoload :Base,            'rails/generators/base'
    autoload :Migration,       'rails/generators/migration'
    autoload :NamedBase,       'rails/generators/named_base'
    autoload :ResourceHelpers, 'rails/generators/resource_helpers'
    autoload :TestCase,        'rails/generators/test_case'

    mattr_accessor :namespace

    DEFAULT_ALIASES = {
      rails: {
        actions: '-a',
        orm: '-o',
        javascripts: '-j',
        javascript_engine: '-je',
        resource_controller: '-c',
        scaffold_controller: '-c',
        stylesheets: '-y',
        stylesheet_engine: '-se',
        template_engine: '-e',
        test_framework: '-t'
      },

      test_unit: {
        fixture_replacement: '-r',
      }
    }

    DEFAULT_OPTIONS = {
      rails: {
        assets: true,
        force_plural: false,
        helper: true,
        integration_tool: nil,
        javascripts: true,
        javascript_engine: :js,
        orm: false,
        resource_controller: :controller,
        resource_route: true,
        scaffold_controller: :scaffold_controller,
        stylesheets: true,
        stylesheet_engine: :css,
        test_framework: false,
        template_engine: :erb
      }
    }

    def self.configure!(config) #:nodoc:
      no_color! unless config.colorize_logging
      aliases.deep_merge! config.aliases
      options.deep_merge! config.options
      fallbacks.merge! config.fallbacks
      templates_path.concat config.templates
      templates_path.uniq!
      hide_namespaces(*config.hidden_namespaces)
    end

    def self.templates_path #:nodoc:
      @templates_path ||= []
    end

    def self.aliases #:nodoc:
      @aliases ||= DEFAULT_ALIASES.dup
    end

    def self.options #:nodoc:
      @options ||= DEFAULT_OPTIONS.dup
    end

    # Hold configured generators fallbacks. If a plugin developer wants a
    # generator group to fallback to another group in case of missing generators,
    # they can add a fallback.
    #
    # For example, shoulda is considered a test_framework and is an extension
    # of test_unit. However, most part of shoulda generators are similar to
    # test_unit ones.
    #
    # Shoulda then can tell generators to search for test_unit generators when
    # some of them are not available by adding a fallback:
    #
    #   Rails::Generators.fallbacks[:shoulda] = :test_unit
    def self.fallbacks
      @fallbacks ||= {}
    end

    # Remove the color from output.
    def self.no_color!
      Thor::Base.shell = Thor::Shell::Basic
    end

    # Track all generators subclasses.
    def self.subclasses
      @subclasses ||= []
    end

    # Rails finds namespaces similar to thor, it only adds one rule:
    #
    # Generators names must end with "_generator.rb". This is required because Rails
    # looks in load paths and loads the generator just before it's going to be used.
    #
    #   find_by_namespace :webrat, :rails, :integration
    #
    # Will search for the following generators:
    #
    #   "rails:webrat", "webrat:integration", "webrat"
    #
    # Notice that "rails:generators:webrat" could be loaded as well, what
    # Rails looks for is the first and last parts of the namespace.
    def self.find_by_namespace(name, base=nil, context=nil) #:nodoc:
      lookups = []
      lookups << "#{base}:#{name}"    if base
      lookups << "#{name}:#{context}" if context

      unless base || context
        unless name.to_s.include?(?:)
          lookups << "#{name}:#{name}"
          lookups << "rails:#{name}"
        end
        lookups << "#{name}"
      end

      lookup(lookups)

      namespaces = Hash[subclasses.map { |klass| [klass.namespace, klass] }]

      lookups.each do |namespace|
        klass = namespaces[namespace]
        return klass if klass
      end

      invoke_fallbacks_for(name, base) || invoke_fallbacks_for(context, name)
    end

    # Receives a namespace, arguments and the behavior to invoke the generator.
    # It's used as the default entry point for generate, destroy and update
    # commands.
    def self.invoke(namespace, args=ARGV, config={})
      names = namespace.to_s.split(':')
      if klass = find_by_namespace(names.pop, names.any? && names.join(':'))
        args << "--help" if args.empty? && klass.arguments.any? { |a| a.required? }
        klass.start(args, config)
      else
        options     = sorted_groups.map(&:last).flatten
        suggestions = options.sort_by {|suggested| levenshtein_distance(namespace.to_s, suggested) }.first(3)
        msg =  "Could not find generator '#{namespace}'. "
        msg << "Maybe you meant #{ suggestions.map {|s| "'#{s}'"}.join(" or ") }\n"
        msg << "Run `rails generate --help` for more options."
        puts msg
      end
    end

    # Returns an array of generator namespaces that are hidden.
    # Generator namespaces may be hidden for a variety of reasons.
    # Some are aliased such as "rails:migration" and can be
    # invoked with the shorter "migration", others are private to other generators
    # such as "css:scaffold".
    def self.hidden_namespaces
      @hidden_namespaces ||= begin
        orm      = options[:rails][:orm]
        test     = options[:rails][:test_framework]
        template = options[:rails][:template_engine]
        css      = options[:rails][:stylesheet_engine]

        [
          "rails",
          "resource_route",
          "#{orm}:migration",
          "#{orm}:model",
          "#{test}:controller",
          "#{test}:helper",
          "#{test}:integration",
          "#{test}:mailer",
          "#{test}:model",
          "#{test}:scaffold",
          "#{test}:view",
          "#{template}:controller",
          "#{template}:scaffold",
          "#{template}:mailer",
          "#{css}:scaffold",
          "#{css}:assets",
          "css:assets",
          "css:scaffold"
        ]
      end
    end

    class << self
      def hide_namespaces(*namespaces)
        hidden_namespaces.concat(namespaces)
      end
      alias hide_namespace hide_namespaces
    end

    # Show help message with available generators.
    def self.help(command = 'generate')
      puts "Usage: rails #{command} GENERATOR [args] [options]"
      puts
      puts "General options:"
      puts "  -h, [--help]     # Print generator's options and usage"
      puts "  -p, [--pretend]  # Run but do not make any changes"
      puts "  -f, [--force]    # Overwrite files that already exist"
      puts "  -s, [--skip]     # Skip files that already exist"
      puts "  -q, [--quiet]    # Suppress status output"
      puts
      puts "Please choose a generator below."
      puts

      print_generators
    end

    def self.public_namespaces
      lookup!
      subclasses.map { |k| k.namespace }
    end

    def self.print_generators
      sorted_groups.each { |b, n| print_list(b, n) }
    end

    def self.sorted_groups
      namespaces = public_namespaces
      namespaces.sort!
      groups = Hash.new { |h,k| h[k] = [] }
      namespaces.each do |namespace|
        base = namespace.split(':').first
        groups[base] << namespace
      end
      rails = groups.delete("rails")
      rails.map! { |n| n.sub(/^rails:/, '') }
      rails.delete("app")
      rails.delete("plugin")

      hidden_namespaces.each { |n| groups.delete(n.to_s) }

      [["rails", rails]] + groups.sort.to_a
    end

    protected

      # This code is based directly on the Text gem implementation
      # Returns a value representing the "cost" of transforming str1 into str2
      def self.levenshtein_distance str1, str2
        s = str1
        t = str2
        n = s.length
        m = t.length
        max = n/2

        return m if (0 == n)
        return n if (0 == m)
        return n if (n - m).abs > max

        d = (0..m).to_a
        x = nil

        str1.each_char.each_with_index do |char1,i|
          e = i+1

          str2.each_char.each_with_index do |char2,j|
            cost = (char1 == char2) ? 0 : 1
            x = [
                 d[j+1] + 1, # insertion
                 e + 1,      # deletion
                 d[j] + cost # substitution
                ].min
            d[j] = e
            e = x
          end

          d[m] = x
        end

        return x
      end

      # Prints a list of generators.
      def self.print_list(base, namespaces) #:nodoc:
        namespaces = namespaces.reject do |n|
          hidden_namespaces.include?(n)
        end

        return if namespaces.empty?
        puts "#{base.camelize}:"

        namespaces.each do |namespace|
          puts("  #{namespace}")
        end

        puts
      end

      # Try fallbacks for the given base.
      def self.invoke_fallbacks_for(name, base) #:nodoc:
        return nil unless base && fallbacks[base.to_sym]
        invoked_fallbacks = []

        Array(fallbacks[base.to_sym]).each do |fallback|
          next if invoked_fallbacks.include?(fallback)
          invoked_fallbacks << fallback

          klass = find_by_namespace(name, fallback)
          return klass if klass
        end

        nil
      end

      # Receives namespaces in an array and tries to find matching generators
      # in the load path.
      def self.lookup(namespaces) #:nodoc:
        paths = namespaces_to_paths(namespaces)

        paths.each do |raw_path|
          ["rails/generators", "generators"].each do |base|
            path = "#{base}/#{raw_path}_generator"

            begin
              require path
              return
            rescue LoadError => e
              raise unless e.message =~ /#{Regexp.escape(path)}$/
            rescue Exception => e
              warn "[WARNING] Could not load generator #{path.inspect}. Error: #{e.message}.\n#{e.backtrace.join("\n")}"
            end
          end
        end
      end

      # This will try to load any generator in the load path to show in help.
      def self.lookup! #:nodoc:
        $LOAD_PATH.each do |base|
          Dir[File.join(base, "{rails/generators,generators}", "**", "*_generator.rb")].each do |path|
            begin
              path = path.sub("#{base}/", "")
              require path
            rescue Exception
              # No problem
            end
          end
        end
      end

      # Convert namespaces to paths by replacing ":" for "/" and adding
      # an extra lookup. For example, "rails:model" should be searched
      # in both: "rails/model/model_generator" and "rails/model_generator".
      def self.namespaces_to_paths(namespaces) #:nodoc:
        paths = []
        namespaces.each do |namespace|
          pieces = namespace.split(":")
          paths << pieces.dup.push(pieces.last).join("/")
          paths << pieces.join("/")
        end
        paths.uniq!
        paths
      end
  end
end

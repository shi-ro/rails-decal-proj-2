require 'optparse'
require 'irb'
require 'irb/completion'

module Rails
  class Console
    class << self
      def start(*args)
        new(*args).start
      end

      def parse_arguments(arguments)
        options = {}

        OptionParser.new do |opt|
          opt.banner = "Usage: rails console [environment] [options]"
          opt.on('-s', '--sandbox', 'Rollback database modifications on exit.') { |v| options[:sandbox] = v }
          opt.on("-e", "--environment=name", String,
                  "Specifies the environment to run this console under (test/development/production).",
                  "Default: development") { |v| options[:environment] = v.strip }
          opt.on("--debugger", 'Enables the debugger.') do |v|
            if RUBY_VERSION < '2.0.0'
              options[:debugger] = v
            else
              puts "=> Notice: debugger option is ignored since Ruby 2.0 and " \
                   "it will be removed in future versions."
            end
          end
          opt.parse!(arguments)
        end

        if arguments.first && arguments.first[0] != '-'
          env = arguments.first
          if available_environments.include? env
            options[:environment] = env
          else
            options[:environment] = %w(production development test).detect {|e| e =~ /^#{env}/} || env
          end
        end

        options
      end

      private

        def available_environments
          Dir['config/environments/*.rb'].map { |fname| File.basename(fname, '.*') }
        end
    end

    attr_reader :options, :app, :console

    def initialize(app, options={})
      @app     = app
      @options = options

      app.sandbox = sandbox?
      app.load_console

      @console = app.config.console || IRB
    end

    def sandbox?
      options[:sandbox]
    end

    def environment
      options[:environment] ||= ENV['RAILS_ENV'] || ENV['RACK_ENV'] || 'development'
    end

    def environment?
      environment
    end

    def set_environment!
      Rails.env = environment
    end

    if RUBY_VERSION < '2.0.0'
      def debugger?
        options[:debugger]
      end

      def require_debugger
        require 'debugger'
        puts "=> Debugger enabled"
      rescue LoadError
        puts "You're missing the 'debugger' gem. Add it to your Gemfile, bundle it and try again."
        exit(1)
      end
    end

    def start
      if RUBY_VERSION < '2.0.0'
        require_debugger if debugger?
      end

      set_environment! if environment?

      if sandbox?
        puts "Loading #{Rails.env} environment in sandbox (Rails #{Rails.version})"
        puts "Any modifications you make will be rolled back on exit"
      else
        puts "Loading #{Rails.env} environment (Rails #{Rails.version})"
      end

      if defined?(console::ExtendCommandBundle)
        console::ExtendCommandBundle.send :include, Rails::ConsoleMethods
      end
      console.start
    end
  end
end

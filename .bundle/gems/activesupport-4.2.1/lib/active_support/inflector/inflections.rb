require 'thread_safe'
require 'active_support/core_ext/array/prepend_and_append'
require 'active_support/i18n'

module ActiveSupport
  module Inflector
    extend self

    # A singleton instance of this class is yielded by Inflector.inflections,
    # which can then be used to specify additional inflection rules. If passed
    # an optional locale, rules for other languages can be specified. The
    # default locale is <tt>:en</tt>. Only rules for English are provided.
    #
    #   ActiveSupport::Inflector.inflections(:en) do |inflect|
    #     inflect.plural /^(ox)$/i, '\1\2en'
    #     inflect.singular /^(ox)en/i, '\1'
    #
    #     inflect.irregular 'octopus', 'octopi'
    #
    #     inflect.uncountable 'equipment'
    #   end
    #
    # New rules are added at the top. So in the example above, the irregular
    # rule for octopus will now be the first of the pluralization and
    # singularization rules that is runs. This guarantees that your rules run
    # before any of the rules that may already have been loaded.
    class Inflections
      @__instance__ = ThreadSafe::Cache.new

      def self.instance(locale = :en)
        @__instance__[locale] ||= new
      end

      attr_reader :plurals, :singulars, :uncountables, :humans, :acronyms, :acronym_regex

      def initialize
        @plurals, @singulars, @uncountables, @humans, @acronyms, @acronym_regex = [], [], [], [], {}, /(?=a)b/
      end

      # Private, for the test suite.
      def initialize_dup(orig) # :nodoc:
        %w(plurals singulars uncountables humans acronyms acronym_regex).each do |scope|
          instance_variable_set("@#{scope}", orig.send(scope).dup)
        end
      end

      # Specifies a new acronym. An acronym must be specified as it will appear
      # in a camelized string. An underscore string that contains the acronym
      # will retain the acronym when passed to +camelize+, +humanize+, or
      # +titleize+. A camelized string that contains the acronym will maintain
      # the acronym when titleized or humanized, and will convert the acronym
      # into a non-delimited single lowercase word when passed to +underscore+.
      #
      #   acronym 'HTML'
      #   titleize 'html'     # => 'HTML'
      #   camelize 'html'     # => 'HTML'
      #   underscore 'MyHTML' # => 'my_html'
      #
      # The acronym, however, must occur as a delimited unit and not be part of
      # another word for conversions to recognize it:
      #
      #   acronym 'HTTP'
      #   camelize 'my_http_delimited' # => 'MyHTTPDelimited'
      #   camelize 'https'             # => 'Https', not 'HTTPs'
      #   underscore 'HTTPS'           # => 'http_s', not 'https'
      #
      #   acronym 'HTTPS'
      #   camelize 'https'   # => 'HTTPS'
      #   underscore 'HTTPS' # => 'https'
      #
      # Note: Acronyms that are passed to +pluralize+ will no longer be
      # recognized, since the acronym will not occur as a delimited unit in the
      # pluralized result. To work around this, you must specify the pluralized
      # form as an acronym as well:
      #
      #    acronym 'API'
      #    camelize(pluralize('api')) # => 'Apis'
      #
      #    acronym 'APIs'
      #    camelize(pluralize('api')) # => 'APIs'
      #
      # +acronym+ may be used to specify any word that contains an acronym or
      # otherwise needs to maintain a non-standard capitalization. The only
      # restriction is that the word must begin with a capital letter.
      #
      #   acronym 'RESTful'
      #   underscore 'RESTful'           # => 'restful'
      #   underscore 'RESTfulController' # => 'restful_controller'
      #   titleize 'RESTfulController'   # => 'RESTful Controller'
      #   camelize 'restful'             # => 'RESTful'
      #   camelize 'restful_controller'  # => 'RESTfulController'
      #
      #   acronym 'McDonald'
      #   underscore 'McDonald' # => 'mcdonald'
      #   camelize 'mcdonald'   # => 'McDonald'
      def acronym(word)
        @acronyms[word.downcase] = word
        @acronym_regex = /#{@acronyms.values.join("|")}/
      end

      # Specifies a new pluralization rule and its replacement. The rule can
      # either be a string or a regular expression. The replacement should
      # always be a string that may include references to the matched data from
      # the rule.
      def plural(rule, replacement)
        @uncountables.delete(rule) if rule.is_a?(String)
        @uncountables.delete(replacement)
        @plurals.prepend([rule, replacement])
      end

      # Specifies a new singularization rule and its replacement. The rule can
      # either be a string or a regular expression. The replacement should
      # always be a string that may include references to the matched data from
      # the rule.
      def singular(rule, replacement)
        @uncountables.delete(rule) if rule.is_a?(String)
        @uncountables.delete(replacement)
        @singulars.prepend([rule, replacement])
      end

      # Specifies a new irregular that applies to both pluralization and
      # singularization at the same time. This can only be used for strings, not
      # regular expressions. You simply pass the irregular in singular and
      # plural form.
      #
      #   irregular 'octopus', 'octopi'
      #   irregular 'person', 'people'
      def irregular(singular, plural)
        @uncountables.delete(singular)
        @uncountables.delete(plural)

        s0 = singular[0]
        srest = singular[1..-1]

        p0 = plural[0]
        prest = plural[1..-1]

        if s0.upcase == p0.upcase
          plural(/(#{s0})#{srest}$/i, '\1' + prest)
          plural(/(#{p0})#{prest}$/i, '\1' + prest)

          singular(/(#{s0})#{srest}$/i, '\1' + srest)
          singular(/(#{p0})#{prest}$/i, '\1' + srest)
        else
          plural(/#{s0.upcase}(?i)#{srest}$/,   p0.upcase   + prest)
          plural(/#{s0.downcase}(?i)#{srest}$/, p0.downcase + prest)
          plural(/#{p0.upcase}(?i)#{prest}$/,   p0.upcase   + prest)
          plural(/#{p0.downcase}(?i)#{prest}$/, p0.downcase + prest)

          singular(/#{s0.upcase}(?i)#{srest}$/,   s0.upcase   + srest)
          singular(/#{s0.downcase}(?i)#{srest}$/, s0.downcase + srest)
          singular(/#{p0.upcase}(?i)#{prest}$/,   s0.upcase   + srest)
          singular(/#{p0.downcase}(?i)#{prest}$/, s0.downcase + srest)
        end
      end

      # Specifies words that are uncountable and should not be inflected.
      #
      #   uncountable 'money'
      #   uncountable 'money', 'information'
      #   uncountable %w( money information rice )
      def uncountable(*words)
        @uncountables += words.flatten.map(&:downcase)
      end

      # Specifies a humanized form of a string by a regular expression rule or
      # by a string mapping. When using a regular expression based replacement,
      # the normal humanize formatting is called after the replacement. When a
      # string is used, the human form should be specified as desired (example:
      # 'The name', not 'the_name').
      #
      #   human /_cnt$/i, '\1_count'
      #   human 'legacy_col_person_name', 'Name'
      def human(rule, replacement)
        @humans.prepend([rule, replacement])
      end

      # Clears the loaded inflections within a given scope (default is
      # <tt>:all</tt>). Give the scope as a symbol of the inflection type, the
      # options are: <tt>:plurals</tt>, <tt>:singulars</tt>, <tt>:uncountables</tt>,
      # <tt>:humans</tt>.
      #
      #   clear :all
      #   clear :plurals
      def clear(scope = :all)
        case scope
          when :all
            @plurals, @singulars, @uncountables, @humans = [], [], [], []
          else
            instance_variable_set "@#{scope}", []
        end
      end
    end

    # Yields a singleton instance of Inflector::Inflections so you can specify
    # additional inflector rules. If passed an optional locale, rules for other
    # languages can be specified. If not specified, defaults to <tt>:en</tt>.
    # Only rules for English are provided.
    #
    #   ActiveSupport::Inflector.inflections(:en) do |inflect|
    #     inflect.uncountable 'rails'
    #   end
    def inflections(locale = :en)
      if block_given?
        yield Inflections.instance(locale)
      else
        Inflections.instance(locale)
      end
    end
  end
end

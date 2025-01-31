module ActiveModel

  # == Active \Model \Translation
  #
  # Provides integration between your object and the Rails internationalization
  # (i18n) framework.
  #
  # A minimal implementation could be:
  #
  #   class TranslatedPerson
  #     extend ActiveModel::Translation
  #   end
  #
  #   TranslatedPerson.human_attribute_name('my_attribute')
  #   # => "My attribute"
  #
  # This also provides the required class methods for hooking into the
  # Rails internationalization API, including being able to define a
  # class based +i18n_scope+ and +lookup_ancestors+ to find translations in
  # parent classes.
  module Translation
    include ActiveModel::Naming

    # Returns the +i18n_scope+ for the class. Overwrite if you want custom lookup.
    def i18n_scope
      :activemodel
    end

    # When localizing a string, it goes through the lookup returned by this
    # method, which is used in ActiveModel::Name#human,
    # ActiveModel::Errors#full_messages and
    # ActiveModel::Translation#human_attribute_name.
    def lookup_ancestors
      self.ancestors.select { |x| x.respond_to?(:model_name) }
    end

    # Transforms attribute names into a more human format, such as "First name"
    # instead of "first_name".
    #
    #   Person.human_attribute_name("first_name") # => "First name"
    #
    # Specify +options+ with additional translating options.
    def human_attribute_name(attribute, options = {})
      options   = { count: 1 }.merge!(options)
      parts     = attribute.to_s.split(".")
      attribute = parts.pop
      namespace = parts.join("/") unless parts.empty?
      attributes_scope = "#{self.i18n_scope}.attributes"

      if namespace
        defaults = lookup_ancestors.map do |klass|
          :"#{attributes_scope}.#{klass.model_name.i18n_key}/#{namespace}.#{attribute}"
        end
        defaults << :"#{attributes_scope}.#{namespace}.#{attribute}"
      else
        defaults = lookup_ancestors.map do |klass|
          :"#{attributes_scope}.#{klass.model_name.i18n_key}.#{attribute}"
        end
      end

      defaults << :"attributes.#{attribute}"
      defaults << options.delete(:default) if options[:default]
      defaults << attribute.humanize

      options[:default] = defaults
      I18n.translate(defaults.shift, options)
    end
  end
end

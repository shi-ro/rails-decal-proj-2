require 'active_support/core_ext/hash/indifferent_access'

module ActiveRecord
  # Store gives you a thin wrapper around serialize for the purpose of storing hashes in a single column.
  # It's like a simple key/value store baked into your record when you don't care about being able to
  # query that store outside the context of a single record.
  #
  # You can then declare accessors to this store that are then accessible just like any other attribute
  # of the model. This is very helpful for easily exposing store keys to a form or elsewhere that's
  # already built around just accessing attributes on the model.
  #
  # Make sure that you declare the database column used for the serialized store as a text, so there's
  # plenty of room.
  #
  # You can set custom coder to encode/decode your serialized attributes to/from different formats.
  # JSON, YAML, Marshal are supported out of the box. Generally it can be any wrapper that provides +load+ and +dump+.
  #
  # NOTE - If you are using PostgreSQL specific columns like +hstore+ or +json+ there is no need for
  # the serialization provided by +store+. Simply use +store_accessor+ instead to generate
  # the accessor methods. Be aware that these columns use a string keyed hash and do not allow access
  # using a symbol.
  #
  # Examples:
  #
  #   class User < ActiveRecord::Base
  #     store :settings, accessors: [ :color, :homepage ], coder: JSON
  #   end
  #
  #   u = User.new(color: 'black', homepage: '37signals.com')
  #   u.color                          # Accessor stored attribute
  #   u.settings[:country] = 'Denmark' # Any attribute, even if not specified with an accessor
  #
  #   # There is no difference between strings and symbols for accessing custom attributes
  #   u.settings[:country]  # => 'Denmark'
  #   u.settings['country'] # => 'Denmark'
  #
  #   # Add additional accessors to an existing store through store_accessor
  #   class SuperUser < User
  #     store_accessor :settings, :privileges, :servants
  #   end
  #
  # The stored attribute names can be retrieved using +stored_attributes+.
  #
  #   User.stored_attributes[:settings] # [:color, :homepage]
  #
  # == Overwriting default accessors
  #
  # All stored values are automatically available through accessors on the Active Record
  # object, but sometimes you want to specialize this behavior. This can be done by overwriting
  # the default accessors (using the same name as the attribute) and calling <tt>super</tt>
  # to actually change things.
  #
  #   class Song < ActiveRecord::Base
  #     # Uses a stored integer to hold the volume adjustment of the song
  #     store :settings, accessors: [:volume_adjustment]
  #
  #     def volume_adjustment=(decibels)
  #       super(decibels.to_i)
  #     end
  #
  #     def volume_adjustment
  #       super.to_i
  #     end
  #   end
  module Store
    extend ActiveSupport::Concern

    included do
      class << self
        attr_accessor :local_stored_attributes
      end
    end

    module ClassMethods
      def store(store_attribute, options = {})
        serialize store_attribute, IndifferentCoder.new(options[:coder])
        store_accessor(store_attribute, options[:accessors]) if options.has_key? :accessors
      end

      def store_accessor(store_attribute, *keys)
        keys = keys.flatten

        _store_accessors_module.module_eval do
          keys.each do |key|
            define_method("#{key}=") do |value|
              write_store_attribute(store_attribute, key, value)
            end

            define_method(key) do
              read_store_attribute(store_attribute, key)
            end
          end
        end

        # assign new store attribute and create new hash to ensure that each class in the hierarchy
        # has its own hash of stored attributes.
        self.local_stored_attributes ||= {}
        self.local_stored_attributes[store_attribute] ||= []
        self.local_stored_attributes[store_attribute] |= keys
      end

      def _store_accessors_module # :nodoc:
        @_store_accessors_module ||= begin
          mod = Module.new
          include mod
          mod
        end
      end

      def stored_attributes
        parent = superclass.respond_to?(:stored_attributes) ? superclass.stored_attributes : {}
        if self.local_stored_attributes
          parent.merge!(self.local_stored_attributes) { |k, a, b| a | b }
        end
        parent
      end
    end

    protected
      def read_store_attribute(store_attribute, key)
        accessor = store_accessor_for(store_attribute)
        accessor.read(self, store_attribute, key)
      end

      def write_store_attribute(store_attribute, key, value)
        accessor = store_accessor_for(store_attribute)
        accessor.write(self, store_attribute, key, value)
      end

    private
      def store_accessor_for(store_attribute)
        type_for_attribute(store_attribute.to_s).accessor
      end

      class HashAccessor # :nodoc:
        def self.read(object, attribute, key)
          prepare(object, attribute)
          object.public_send(attribute)[key]
        end

        def self.write(object, attribute, key, value)
          prepare(object, attribute)
          if value != read(object, attribute, key)
            object.public_send :"#{attribute}_will_change!"
            object.public_send(attribute)[key] = value
          end
        end

        def self.prepare(object, attribute)
          object.public_send :"#{attribute}=", {} unless object.send(attribute)
        end
      end

      class StringKeyedHashAccessor < HashAccessor # :nodoc:
        def self.read(object, attribute, key)
          super object, attribute, key.to_s
        end

        def self.write(object, attribute, key, value)
          super object, attribute, key.to_s, value
        end
      end

      class IndifferentHashAccessor < ActiveRecord::Store::HashAccessor # :nodoc:
        def self.prepare(object, store_attribute)
          attribute = object.send(store_attribute)
          unless attribute.is_a?(ActiveSupport::HashWithIndifferentAccess)
            attribute = IndifferentCoder.as_indifferent_hash(attribute)
            object.send :"#{store_attribute}=", attribute
          end
          attribute
        end
      end

    class IndifferentCoder # :nodoc:
      def initialize(coder_or_class_name)
        @coder =
          if coder_or_class_name.respond_to?(:load) && coder_or_class_name.respond_to?(:dump)
            coder_or_class_name
          else
            ActiveRecord::Coders::YAMLColumn.new(coder_or_class_name || Object)
          end
      end

      def dump(obj)
        @coder.dump self.class.as_indifferent_hash(obj)
      end

      def load(yaml)
        self.class.as_indifferent_hash(@coder.load(yaml || ''))
      end

      def self.as_indifferent_hash(obj)
        case obj
        when ActiveSupport::HashWithIndifferentAccess
          obj
        when Hash
          obj.with_indifferent_access
        else
          ActiveSupport::HashWithIndifferentAccess.new
        end
      end
    end
  end
end

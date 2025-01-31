# This is private interface.
#
# Rails components cherry pick from Active Support as needed, but there are a
# few features that are used for sure some way or another and it is not worth
# to put individual requires absolutely everywhere. Think blank? for example.
#
# This file is loaded by every Rails component except Active Support itself,
# but it does not belong to the Rails public interface. It is internal to
# Rails and can change anytime.

# Defines Object#blank? and Object#present?.
require 'active_support/core_ext/object/blank'

# Rails own autoload, eager_load, etc.
require 'active_support/dependencies/autoload'

# Support for ClassMethods and the included macro.
require 'active_support/concern'

# Defines Class#class_attribute.
require 'active_support/core_ext/class/attribute'

# Defines Module#delegate.
require 'active_support/core_ext/module/delegation'

# Defines ActiveSupport::Deprecation.
require 'active_support/deprecation'

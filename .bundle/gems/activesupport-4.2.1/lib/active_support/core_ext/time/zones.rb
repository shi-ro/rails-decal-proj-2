require 'active_support/time_with_zone'
require 'active_support/core_ext/time/acts_like'
require 'active_support/core_ext/date_and_time/zones'

class Time
  include DateAndTime::Zones
  class << self
    attr_accessor :zone_default

    # Returns the TimeZone for the current request, if this has been set (via Time.zone=).
    # If <tt>Time.zone</tt> has not been set for the current request, returns the TimeZone specified in <tt>config.time_zone</tt>.
    def zone
      Thread.current[:time_zone] || zone_default
    end

    # Sets <tt>Time.zone</tt> to a TimeZone object for the current request/thread.
    #
    # This method accepts any of the following:
    #
    # * A Rails TimeZone object.
    # * An identifier for a Rails TimeZone object (e.g., "Eastern Time (US & Canada)", <tt>-5.hours</tt>).
    # * A TZInfo::Timezone object.
    # * An identifier for a TZInfo::Timezone object (e.g., "America/New_York").
    #
    # Here's an example of how you might set <tt>Time.zone</tt> on a per request basis and reset it when the request is done.
    # <tt>current_user.time_zone</tt> just needs to return a string identifying the user's preferred time zone:
    #
    #   class ApplicationController < ActionController::Base
    #     around_filter :set_time_zone
    #
    #     def set_time_zone
    #       if logged_in?
    #         Time.use_zone(current_user.time_zone) { yield }
    #       else
    #         yield
    #       end
    #     end
    #   end
    def zone=(time_zone)
      Thread.current[:time_zone] = find_zone!(time_zone)
    end

    # Allows override of <tt>Time.zone</tt> locally inside supplied block; resets <tt>Time.zone</tt> to existing value when done.
    def use_zone(time_zone)
      new_zone = find_zone!(time_zone)
      begin
        old_zone, ::Time.zone = ::Time.zone, new_zone
        yield
      ensure
        ::Time.zone = old_zone
      end
    end

    # Returns a TimeZone instance or nil, or raises an ArgumentError for invalid timezones.
    def find_zone!(time_zone)
      if !time_zone || time_zone.is_a?(ActiveSupport::TimeZone)
        time_zone
      else
        # lookup timezone based on identifier (unless we've been passed a TZInfo::Timezone)
        unless time_zone.respond_to?(:period_for_local)
          time_zone = ActiveSupport::TimeZone[time_zone] || TZInfo::Timezone.get(time_zone)
        end

        # Return if a TimeZone instance, or wrap in a TimeZone instance if a TZInfo::Timezone
        if time_zone.is_a?(ActiveSupport::TimeZone)
          time_zone
        else
          ActiveSupport::TimeZone.create(time_zone.name, nil, time_zone)
        end
      end
    rescue TZInfo::InvalidTimezoneIdentifier
      raise ArgumentError, "Invalid Timezone: #{time_zone}"
    end

    def find_zone(time_zone)
      find_zone!(time_zone) rescue nil
    end
  end
end

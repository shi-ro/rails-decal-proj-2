module TZInfo

  # A proxy class representing a timezone with a given identifier. TimezoneProxy
  # inherits from Timezone and can be treated like any Timezone loaded with
  # Timezone.get.
  #
  # The first time an attempt is made to access the data for the timezone, the 
  # real Timezone is loaded. If the proxy's identifier was not valid, then an 
  # exception will be raised at this point.  
  class TimezoneProxy < Timezone
    # Construct a new TimezoneProxy for the given identifier. The identifier
    # is not checked when constructing the proxy. It will be validated on the
    # when the real Timezone is loaded.
    def self.new(identifier)
      # Need to override new to undo the behaviour introduced in Timezone#new.
      tzp = super()
      tzp.send(:setup, identifier)
      tzp
    end
        
    # The identifier of the timezone, e.g. "Europe/Paris".
    def identifier
      @real_timezone ? @real_timezone.identifier : @identifier
    end
    
    # Returns the TimezonePeriod for the given UTC time. utc can either be
    # a DateTime, Time or integer timestamp (Time.to_i). Any timezone 
    # information in utc is ignored (it is treated as a UTC time).        
    def period_for_utc(utc)            
      real_timezone.period_for_utc(utc)            
    end
    
    # Returns the set of TimezonePeriod instances that are valid for the given
    # local time as an array. If you just want a single period, use 
    # period_for_local instead and specify how abiguities should be resolved.
    # Returns an empty array if no periods are found for the given time.
    def periods_for_local(local)
      real_timezone.periods_for_local(local)
    end
    
    # Returns the canonical zone for this Timezone.
    def canonical_zone
      real_timezone.canonical_zone
    end
    
    # Dumps this TimezoneProxy for marshalling.
    def _dump(limit)
      identifier
    end
    
    # Loads a marshalled TimezoneProxy.
    def self._load(data)
      TimezoneProxy.new(data)
    end
    
    private
      def setup(identifier)
        @identifier = identifier
        @real_timezone = nil
      end  
    
      def real_timezone
        # Thread-safety: It is possible that the value of @real_timezone may be 
        # calculated multiple times in concurrently executing threads. It is not 
        # worth the overhead of locking to ensure that @real_timezone is only 
        # calculated once.
        @real_timezone ||= Timezone.get(@identifier)
      end     
  end 
end

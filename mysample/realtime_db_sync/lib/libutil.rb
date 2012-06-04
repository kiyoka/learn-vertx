require 'digest'
require 'date'

module DBSync
  class Util
    def initialize()
    end

    # return message digest for str.
    def digest( str )
      Digest::SHA1.hexdigest( str )
    end

    # reutnr the currentTime in Unixtime
    def currentTime( )
      dt = DateTime::now()
      currentDate = dt.strftime( "%s" ) + ":" + dt.strftime( "%x:%X" )
      currentDate
    end
  end
end

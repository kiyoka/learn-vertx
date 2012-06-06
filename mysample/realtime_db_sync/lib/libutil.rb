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

    # return the currentTime in Unixtime
    def currentTime( )
      dt = DateTime::now()
      currentDate = dt.strftime( "%s" ) + "=" + dt.strftime( "%x:%X" )
      currentDate
    end

    def _splitKey( key )
      key.split( /[=]/ )
    end

    def key_seconds( key )
      arr = _splitKey( key )
      if 2 < arr.size
        arr[0].to_i
      else
        nil
      end
    end

    def key_timestamp( key )
      arr = _splitKey( key )
      if 2 < arr.size
        arr[1]
      else
        nil
      end
    end

    def key_digest( key )
      arr = _splitKey( key )
      if 2 < arr.size
        arr[2]
      else
        nil
      end
    end
  end
end

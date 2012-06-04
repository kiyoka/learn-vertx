require 'gdbm'

module DBSync
  class MasterDB
    def initialize( basepath = "/tmp/")
      @basepath = basepath
    end

    def open( username )
      @db = GDBM.new( @basepath + username + ".db" )
      if not @db
        raise RuntimeError, sprintf( "DBM.new error: file=%s", username + ".db" )
      end
      @username = username
    end

    def getList( )
      forward_match_keys( "" )
    end

    def getValue( key )
      fallback = false
      val = @db[ key ]
      if val
        val.force_encoding("UTF-8")
      else
        fallback
      end
    end

    def insertValue( key, value )
      @db[ key.force_encoding("ASCII-8BIT") ] = value.force_encoding("ASCII-8BIT")
    end

    def deleteValue( key )
      @db.delete( key )
    end

    def forward_match_keys( prefix )
      @db.keys( ).select {|key|
        key.match( "^" + prefix )
      }
    end

    def clear
      @db.clear
    end

    def close
      @db.close
    end
  end
end

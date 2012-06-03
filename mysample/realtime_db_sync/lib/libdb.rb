require 'gdbm'

module DBSync
  class MasterDB
    def initialize()
    end

    def open( name )
      @db = GDBM.new( name )
      if not @db
        raise RuntimeError, sprintf( "DBM.new error: file=%s", name )
      end
    end

    def getList( username )
      forward_match_keys( username )
    end

    def getValue( username, key )
      fallback = false
      val = @db[ key ]
      if val
        val.force_encoding("UTF-8")
      else
        fallback
      end
    end

    def insertValue( username, key, value )
      @db[ key.force_encoding("ASCII-8BIT") ] = value.force_encoding("ASCII-8BIT")
    end

    def deleteValue( username, key )
      @db.delete( key )
    end

    def forward_match_keys( prefix )
      @db.keys( ).select {|key|
        key.match( "^" + prefix )
      }
    end

    def close
      @db.close
    end
  end
end

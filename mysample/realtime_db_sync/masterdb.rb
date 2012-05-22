require 'vertx'
require 'json/pure'
require 'pp'
require 'cgi'
require 'date'
require 'memcache'

masterHash = {}
notifyHash = Memcache.new( :server => "localhost:11211" )
#notifyHash = Vertx::SharedData::get_hash("notifyHash")

masterdb_server = Vertx::HttpServer.new
masterdb_server.request_handler do |req|

  puts "MasterDB: An HTTP request has been received"

  kv = nil

  req.body_handler do |body|
    puts "The total body received was #{body.length} bytes, path is #{req.path}."

    query = CGI::parse( req.query )
    username = query[ 'username' ].first

    params = CGI::parse( body.to_s )
    if params.key?( 'kv' )
      kv = JSON( params[ 'kv' ].first )
    end
  end

  case req.path
  when "/insertValue"
    pp ["insertValue",  kv ]
    
    # update db
    kv.each { |k,v|
      masterHash[ k ] = v
    }
    
    # notify to all client
    dt = DateTime::now()
    currentDate = dt.strftime( "%s" ) + " " + dt.strftime( "%x %X" )
    pp [ "currentDate", currentDate ]
    notifyHash[ username ] = currentDate
    Vertx::EventBus.send('bus.notify', 'new values came, you must sync.')
    
  when "/getList"
    #masterHash.keys.each { |k|
    #  req.response.write_str( k + "\n" )
    #}
    req.response.end( "aaa\n" )
  end

end.listen(8081, 'localhost')

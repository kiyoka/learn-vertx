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

  req.body_handler do |body|
    puts "The total body received was #{body.length} bytes, path is #{req.path}."

    query = CGI::parse( req.query )
    username = query[ 'username' ].first

    case req.path
    when "/insertValue"
      kv = JSON::parse( body.to_s )
      pp ["insertValue", kv ]
      
      # update db
      kv.each { |k,v|
        masterHash[ k ] = v
      
        # notify to all client
        notifyHash[ username ] = k
        Vertx::EventBus.send('bus.notify', 'new values came, you must sync.')
      }
      req.response.end()

    when "/getList"
      str = masterHash.keys.join( "\n" )
      pp ["getList", str ]
      req.response.end( str )

    when "/getValue"
      k = body.to_s.chomp
      str = if masterHash[ k ]
              masterHash[ k ]
            else
              ""
            end
      pp ["getValue", k, str ]
      req.response.end( str )
    end

  end
end.listen(8081, 'localhost')

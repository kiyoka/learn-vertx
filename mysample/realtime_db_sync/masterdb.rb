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

    params = CGI::parse( body.to_s )
    values = JSON( params[ 'values' ].first )

    case req.path
    when "/putValues"
      pp ["putValues",  values ]

      # update db
      values.each { |key,value|
        masterHash[ key ] = value
      }

      # notify to all client
      dt = DateTime::now()
      currentDate = dt.strftime( "%s" ) + " " + dt.strftime( "%x %X" )
      pp [ "currentDate", currentDate ]
      notifyHash[ username ] = currentDate
      Vertx::EventBus.send('bus.notify', 'new values came, you must sync.')

    when "/getValues"
      pp ["getValues",  values ]
    end

    req.response.end
  end

end.listen(8081, 'localhost')

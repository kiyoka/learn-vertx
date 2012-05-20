require 'vertx'
require 'json/pure'
require 'pp'
require 'cgi'

#require 'dbm'
#masterHash = DBM.new( "/tmp/masterHash" )

masterHash = {}

masterdb_server = Vertx::HttpServer.new
masterdb_server.request_handler do |req|

  puts "An HTTP request has been received (method=#{req.method})"

  req.body_handler do |body|
    puts "The total body received was #{body.length} bytes, path is #{req.path}."

    params = CGI::parse( body.to_s )
    values = JSON( params[ 'values' ][0] )

    case req.path
    when "/putValues"
      pp ["putValues",  values ]

      # update db
      values.each { |key,value|
        masterHash[ key ] = value
      }

      # notify to all client
      Vertx::EventBus.send('bus.notify', 'new values came, you must sync.')

    when "/getValues"
      pp ["getValues",  values ]
    end

    req.response.end
  end

end.listen(8081, 'localhost')


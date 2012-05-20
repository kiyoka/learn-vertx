require 'vertx'
require 'cgi'
require 'memcache'

# use http://en.wikipedia.org/wiki/Chunked_transfer_encoding

INTERVAL = 0.5

notifyHash = Memcache.new( :server => "localhost:11211" )
#Vertx::SharedData::get_hash("notifyHash")

def notify( res, str )
  res.write_str( "notify! #{str}\n"  )
end

notifier = Vertx::HttpServer.new
notifier.request_handler do |req|
  puts 'Notifier: An HTTP request has been received'

  req.end_handler do
    query = CGI::parse( req.query )
    username = query[ 'username' ].first
    # Now send back a response
    req.response.chunked = true

    # wait for notify event.
    got = nil
    (10 / INTERVAL).to_i.times { |i|
      if notifyHash[ username ]
        if got != notifyHash[ username ]
          got = notifyHash[ username ]
          notify( req.response, got )
        end
      end
      sleep( INTERVAL )
    }

    req.response.end
  end

end.listen(8080, 'localhost')

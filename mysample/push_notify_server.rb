require 'vertx'

# use http://en.wikipedia.org/wiki/Chunked_transfer_encoding

def notify( res, no )
      res.write_str( "notify! #{no}\n" )
      sleep( 1 )
end

server = Vertx::HttpServer.new
server.request_handler do |req|
  puts 'An HTTP request has been received'

  req.end_handler do
    # Now send back a response
    req.response.chunked = true

    10.times {|i|
      notify( req.response, i+1 )
    }

    req.response.end
  end

end.listen(8080, 'localhost')

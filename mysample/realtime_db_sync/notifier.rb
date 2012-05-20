require 'vertx'

# use http://en.wikipedia.org/wiki/Chunked_transfer_encoding

def notify( res )
  res.write_str( "notify!\n"  )
end

Vertx::EventBus.register_handler('bus.notify') do |message|
  puts("DUMMY: I received a message from masterdb.rb #{message.body}")  
end


notifier = Vertx::HttpServer.new
notifier.request_handler do |req|
  puts 'An HTTP request has been received'

  req.end_handler do

    # Now send back a response
    req.response.chunked = true

    handlerId = Vertx::EventBus.register_handler('bus.notify') do |message|
      puts("I received a message from masterdb.rb #{message.body}")
      notify( req )
    end

    # wait for notify event.
    60.times { |i|
      sleep( 1 )
    }

    req.response.end

    Vertx::EventBus.unregister_handler( handlerId )
  end

end.listen(8080, 'localhost')

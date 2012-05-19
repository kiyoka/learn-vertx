require "vertx"

Vertx::HttpServer.new.request_handler do |req|
    file = req.uri == "/" ? "index.html" : req.uri
    req.response.send_file "webroot/#{file}"
end.listen(8080)

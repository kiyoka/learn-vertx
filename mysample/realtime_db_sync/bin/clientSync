require 'net/http'
require 'uri'
require 'open-uri'
require 'pp'


SERVER_HOST='localhost'

def sync_db( username )
  puts "sync db..."
  list = open( sprintf( "http://%s:8081/getList?username=%s", SERVER_HOST, username ), "r" ) {|f|
    f.readlines
  }
  pp list
end

def wait_notify( username )
  uri = URI.parse("http://localhost:8080/?username=#{username}")
  Net::HTTP.start(uri.host, uri.port) do |http|
    request = Net::HTTP::Get.new(uri.request_uri)
    http.request(request) do |response|
      raise 'Response is not chuncked' unless response.chunked?
      response.read_body do |chunk|
        puts "#{chunk}"
        return chunk.chomp
      end
    end
  end
end


def main
  if 1 > ARGV.length
    puts "usage: clientdb.rb [USERNAME]"
    exit 1
  end
  result = wait_notify( ARGV[0] )
  if result
    sync_db( ARGV[0] )
  end
end

main

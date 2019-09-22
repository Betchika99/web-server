require 'socket'
require_relative 'config.rb'
require_relative 'query.rb'
require_relative 'validate.rb'
require_relative 'response.rb'

server = TCPServer.new(PORT)

while (session = server.accept)
    # puts "Request: #{session.gets}"
    request = session.gets

    if !check_request(request)
        puts "BAD REQUEST"
        session.close
        next
    end

    q = Query.new
    q.init(request)
    if !check_query(q)
        session.print create_response("NOT_ALLOWED", q)
        session.close
        next
    end  

    # session.print "HTTP/1.1 200/OK\r\nContent-type: text/html\r\n\r\n"
    # session.print "<html><body><h1>#{Time.now}</h1></body></html>\r\n"
    session.print create_response("OK", q)
    session.close
end
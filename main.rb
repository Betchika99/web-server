require 'socket'
require_relative 'config.rb'
require_relative 'query.rb'
require_relative 'validate.rb'
require_relative 'response.rb'

server = TCPServer.new(PORT)

busy_workers_count = 0

main = Process.pid

loop do
    break if busy_workers_count == WORKERS_COUNT
    busy_workers_count += 1
    if Process.pid == main
        Process.fork
    end
end

if Process.pid == main
  print "Me (main)   : " + Process.pid.to_s
  print "\n"
else
  print "Me (clone)  : " + Process.pid.to_s
  print "\n"
end

while (session = server.accept)
    request = session.gets

    if !check_request(request)
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

    session.print create_response("OK", q)
    session.close
end
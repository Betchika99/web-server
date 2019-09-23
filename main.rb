require 'socket'
require_relative 'config.rb'
require_relative 'query.rb'
require_relative 'validate.rb'
require_relative 'response.rb'

server = TCPServer.new(PORT)

busy_workers_count = 0

main = Process.pid

workers = []

loop do
    break if busy_workers_count == WORKERS_COUNT
    busy_workers_count += 1
    if Process.pid == main
        # Process.fork
        pid = fork do
            workers.push pid
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

                if !check_url(q) && q.file == "index.html"
                    session.print create_response("FORBIDDEN", q)
                    session.close
                    next
                end

                if !check_url(q)
                    session.print create_response("NOT_FOUND", q)
                    session.close
                    next
                end
                        
                session.print create_response("OK", q)
                session.close
            end
        end
    end
end

for pid in workers do
    # Process.detach(pid)
    Process.waitpid(pid)
end

# while (session = server.accept)
#     request = session.gets
#     puts "REQUEST: #{request}"
#     puts "CHECK_REQUEST: #{check_request(request)}"
#     if !check_request(request)
#         session.close
#         next
#     end
    
#     q = Query.new
#     q.init(request)
#     if !check_query(q)
#         session.print create_response("NOT_ALLOWED", q)
#         session.close
#         next
#     end

#     puts "FIIIIIIIILE: #{q.file}"
#     if !check_url(q) && q.file == "index.html"
#         session.print create_response("FORBIDDEN", q)
#         session.close
#         next
#     end

#     if !check_url(q)
#         session.print create_response("NOT_FOUND", q)
#         session.close
#         next
#     end
            
#     session.print create_response("OK", q)
#     session.close
# end
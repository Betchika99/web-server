require 'socket'
require_relative 'config.rb'
require_relative 'query.rb'
require_relative 'validate.rb'
require_relative 'response.rb'
require_relative 'file.rb'

config, length = open_file(PATH_TO_CONFIG)
available_workers_count = config.split("\n").select {|row| row.include? "cpu_limit"}[0].split(" ")[1].to_i
static_folder = config.split("\n").select {|row| row.include? "document_root"}[0].split(" ")[1]

server = TCPServer.new(PORT)

busy_workers_count = 0

main = Process.pid

workers = []

begin
loop do
    break if busy_workers_count == WORKERS_COUNT
    busy_workers_count += 1
    if Process.pid == main
        pid = fork do
            Signal.trap("TERM") do
                shutdown()
            end

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
                q.init(request, static_folder)
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

rescue SystemExit, Interrupt
    raise
  rescue Exception => e
    for pid in workers do
        Process.kill("TERM", pid)
    end
    shutdown()
end

while true do
end

# while (session = server.accept)
#     request = session.gets
#     if !check_request(request)
#         session.close
#         next
#     end
    
#     q = Query.new
#     q.init(request, static_folder)
#     if !check_query(q)
#         session.print create_response("NOT_ALLOWED", q)
#         session.close
#         next
#     end

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
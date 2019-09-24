require 'uri'

class Query
    attr_accessor :method, :url, :http_version, :file, :file_type

    def init(request, folder)
        puts "Request: #{request} IN PROCESS #{Process.pid}"

        request_args = request.split(' ')
        @method = request_args[0]
        @url = URI.unescape(request_args[1].split("?").first)
        @http_version = request_args[2]

        @file = @url.split("/").last

        if @file.split(".").length == 1
            @file = "index.html"
            @url += @file
        end

        @file_type = @file.split(".").last
        @url.prepend(folder)
    end

    def get_method
        @method
    end

    def get_url
        @url
    end

    def get_file_type
        allow_types = ['html', 'css', 'js', 'jpg', 'jpeg', 'png', 'gif', 'swf', 'txt']
    
        if !allow_types.include?(@file_type)
            return
        end
    
        return @file_type
    end

end
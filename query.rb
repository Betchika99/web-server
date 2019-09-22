class Query
    attr_accessor :method, :url, :http_version, :file, :file_type

    def init(request)
        puts "Request: #{request}"

        request_args = request.split(' ')
        @method = request_args[0]
        @url = request_args[1]
        @http_version = request_args[2]

        @file = @url.split("/").last
        @file_type = @file.split(".").last
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
            puts "FILE TYPE NOT FOUND"
            return
        end
    
        return @file_type
    end

end
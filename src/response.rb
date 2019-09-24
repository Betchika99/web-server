require_relative 'query.rb'
require_relative 'file.rb'

STATUSES = {
    'NOT_ALLOWED' => 405,
    'NOT_FOUND' => 404,
    'FORBIDDEN' => 403,
    'OK' => 200
}

def create_response(status, query)
    http_version = query.http_version
    status_code = STATUSES[status].to_s + " " + status

    headers = [
        "Server: Highload-Server\r\n",
        "Date: #{Time.now}\r\n",
        "Connection: keep-alive\r\n"
    ]

    if status == "NOT_ALLOWED" || status == "NOT_FOUND" || status == "FORBIDDEN"
        result = http_version + " " + status_code + "\r\n" + headers.reduce(:+) + "\r\n"
        return result
    end

    body = ""

    if type = query.get_file_type
        # content, length = open_file("./http-test-suite" + query.url)
        content, length = open_file(query.url)
        headers.push(add_content_type(type))
        headers.push(add_content_length(length))
        if query.method == 'GET'
            body = content
        end
    end

    result = http_version + " " + status_code + "\r\n" + headers.reduce(:+) + "\r\n" + body
end

def add_content_type(type)
    header = "Content-Type: "

    case type
    when "html"
        header += "text/html\r\n"
    when "css"
        header += "text/css\r\n"
    when "js"
        header += "text/javascript\r\n"
    when "jpg"
        header += "image/jpeg\r\n"
    when "jpeg"
        header += "image/jpeg\r\n"
    when "png"
        header += "image/png\r\n"
    when "gif"
        header += "image/gif\r\n"
    when "swf"
        header += "application/x-shockwave-flash\r\n"
    when "txt"
        header += "text/plain\r\n"
    end

    return header
end

def add_content_length(length)
    header = "Content-Length: " + length.to_s + "\r\n"
end


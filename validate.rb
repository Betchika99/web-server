require_relative 'query.rb'

def check_request(request)
    if request.nil? || request.split(" ").length <= 2 || !(request.include? "\r\n")
        return false
    end

    return true
end

def check_query(query)
    if (query.get_method != 'GET' && query.get_method != 'HEAD')
        return false
    end

    return true
end

def check_url(query)
    begin
    file = open ("./http-test-suite" + query.url)

    rescue Exception => e
        return false
    else
        return true
    end
end
require_relative 'query.rb'

def check_request(request)
    if request.split(" ").length <= 2 || !(request.include? "\r\n")
        return false
    end

    return true
end

def check_query(query)
    if (query.get_method != 'GET' && query.get_method != 'HEAD')
        puts 'VSE PLOHO'
        return false
    end

    puts 'VSE OK'
    return true
end

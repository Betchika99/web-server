def open_file(url)
    file = open url
    content = file.read
    length = File.size(url)
    file.close

    return content, length
end

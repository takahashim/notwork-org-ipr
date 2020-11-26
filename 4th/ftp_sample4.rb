#! /usr/local/bin/ruby

require 'net/ftp'
include Net

ftp = FTP.open('localhost', 'anonymous')

ftp.list('pub').each do |list|
  list.scan(/^(-|d).+?(\S+)$/) do |dir, file|
    next if file == '.' || file == '..'
    case dir
    when '-'; print "file:"
    when 'd'; print "dir:"
    end
    print list, "\n"
  end
end

ftp.quit
ftp.close

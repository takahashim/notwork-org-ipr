#! /usr/local/bin/ruby

require 'net/ftp'
include Net

ftp = FTP.open('localhost', 'anonymous')

ftp.dir.each do |f|
  p f
end

ftp.quit
ftp.close

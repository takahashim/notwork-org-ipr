#! /usr/local/bin/ruby

require 'net/ftp'
include Net

ftp = FTP.open('localhost', 'anonymous')

ftp.getbinaryfile('pub/DUMMY.txt', 'dummy.txt', 4096)

ftp.quit
ftp.close

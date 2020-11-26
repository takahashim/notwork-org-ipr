#! /usr/local/bin/ruby

require 'net/ftp'
include Net

def is_dir(list)
  return true if /^total/ =~ list[0]
  return ture if /^d/ =~ list[0]
  false
end

def is_file(list)
  return true if /^-/ =~ list[0]
  false
end

ftp = FTP.open('localhost', 'anonymous')

list = ftp.list('pub')
p ["list.size > 1", list.size > 1]
p ["is_dir", is_dir(list)]
p ["is_file", is_file(list)]

list = ftp.list('pub/README')
p ["list.size > 1", list.size > 1]
p ["is_dir", is_dir(list)]
p ["is_file", is_file(list)]

ftp.quit
ftp.close

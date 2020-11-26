#!/usr/local/bin/ruby

require "ftplib"
require "getopts"

DEFAULT_URL = ENV['RFC_BASE_URL'] || "ftp://ftp.nic.ad.jp/rfc/"
LOCAL_PATH  = ENV['HOME'] + "/lib/doc/rfc/"

def print_progress nrecv, size
  if size != 0
    ratio = nrecv * 100 / size
    print "\r#{nrecv}/#{size}(#{ratio}%) bytes received. "
    STDOUT.flush
  end
end

# analyze option
getopts("ip", "u:", "o:")

ARGV.push("-index") if $OPT_i
use_passive = $OPT_p
ftp_url     = $OPT_u || DEFAULT_URL
local_path  = $OPT_o || LOCAL_PATH

if ARGV.size == 0
  puts "Usage: getrfc [-i] [-p] [-u URL] [-o dir] number [...]\n"
  puts "-i\tgets rfc-index.txt"
  puts "-p\tpassive mode"
  puts "-u URL\tbase URL (default: #{DEFAULT_URL})"
  puts "-o\toutput directory (default: #{LOCAL_PATH})"
  exit 1
end

# Parse URL
if %r!ftp://(.*?)(/.*)! =~ ftp_url
  host, remote_path = $1, $2
end

if !host || !remote_path
  print "Bad URL is specified.\n"
  exit 1
end

# Connect and login
print "connect to #{host}\n"
s = FTP.new(host)
s.passive = use_passive
print "using passive mode.\n" if s.passive
print s.login

# Real get
ARGV.each do |i|
  remote_file = "#{remote_path}rfc#{i}.txt" 
  local_file  = "#{local_path}rfc#{i}.txt" 

  print "Getting #{remote_file} into #{local_file}.\n"
  begin
    size = s.size(remote_file)
    s.gettextfile(remote_file, local_file) do
      print_progress File.stat(local_file).size, size.to_i
    end
    print_progress File.stat(local_file).size, size.to_i
    print "Done.\n"
  rescue
    print "#{$!}\n"
  end
end

# Logout and close connection
s.close

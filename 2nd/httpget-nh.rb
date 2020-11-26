#!/usr/local/bin/ruby
# httpget-nh.rb -- httpget.rb with Net::HTTP

require 'net/http'
require 'uri'
include URIModule

## URL�μ���
host, port, path = "localhost", 80, "/"
if ARGV[0]
  url = URI.create(ARGV[0])
  host = url.host
  port = url.port.to_i
  path = url.path
end

## ��³����
Net::HTTP.start(host, port) do |http|

  ## �إå���������ƾ��ʬ��
  header, data = http.get( path )
  header.each{|key,value|
    print key,": ",value,"\r\n"
  }
  print "\r\n"
  print data
end

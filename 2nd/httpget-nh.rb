#!/usr/local/bin/ruby
# httpget-nh.rb -- httpget.rb with Net::HTTP

require 'net/http'
require 'uri'
include URIModule

## URLの取得
host, port, path = "localhost", 80, "/"
if ARGV[0]
  url = URI.create(ARGV[0])
  host = url.host
  port = url.port.to_i
  path = url.path
end

## 接続開始
Net::HTTP.start(host, port) do |http|

  ## ヘッダを取得して場合分け
  header, data = http.get( path )
  header.each{|key,value|
    print key,": ",value,"\r\n"
  }
  print "\r\n"
  print data
end

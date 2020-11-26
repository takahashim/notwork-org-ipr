#!/usr/bin/env ruby
# httpget-ha.rb -- httpget.rb with http-access

require 'http-access'
require 'uri'
include URIModule

default_url = 'http://localhost/'

url = ARGV[0] || default_url
u = URI.create(url)

## 接続開始
http = HTTPAccess.new(u.host, u.port, ENV['http_proxy'])
http.request_get(u.path)
http.get_response
http.headers.each{ |line|
  key, value = line.chomp.split(":\s+")
  print key.gsub(/([A-Za-z]+)/){$1.capitalize},": ",value,"\r\n"
}
print "\r\n"
if http.code == '200'
  http.get_data{ |data| print data }
end
http.close

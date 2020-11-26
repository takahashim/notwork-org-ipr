#!/usr/local/bin/ruby
# httpget-nh.rb -- httpget.rb with Net::HTTP

require 'net/http'
require 'uri'
include URIModule

default_url = 'http://localhost/'

## URLの取得
url =  ARGV[0] || default_url
u = URI.create(url)

## 接続開始
Net::HTTP.start(u.host, u.port) do |http|

  ## ヘッダを取得して場合分け
  begin
    header, data = http.get( u.path )
    header.each{|key,value|
      print key.gsub(/([A-Za-z]+)/){$1.capitalize},": ",value,"\r\n"
    }
    print "\r\n"
    print data
    
  ##各種エラー処理
  rescue Net::ProtoRetriableError
    print "This site was moved.\n"
  rescue Net::ProtoFatalError
    print "Fatal Error.\n"
  rescue
    print "Unknown Error.\n"
  end
end

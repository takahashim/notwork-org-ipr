#!/usr/local/bin/ruby
#   httphead.rb -- HEADリクエストで更新時刻を取得

require 'net/http'
require 'uri'
include URIModule

## 引数の処理
if ARGV.length != 1
  print "Usage:  ruby httphead.rb <url>\n"
  exit
end

## URLの解析
url = URI.create(ARGV.shift)
host, port, path = url.host, url.port.to_i, url.path

## プロクシにも対応する
if ENV['http_proxy']
  p_uri = URI.create(ENV['http_proxy'])
  net_http = Net::HTTP::Proxy(p_uri.host, p_uri.port)
else
  net_http = Net::HTTP
end

## 接続開始
net_http.start(host, port) do |http|

  ## ヘッダを取得して場合分け
  header = http.head2( path ) 
  case header

  when Net::SuccessCode  ## 成功
    lm = header['last-modified']
    if lm
      print url,"\n\t",lm,"\n"
    else
      print url,"\n\t(unknown)\n"
    end
  when Net::RetriableCode  ## 移動
    print "#{url}\n\t"
    print "is Moved! -> #{header['location']}\n"

  else  ## 失敗
    print "Error...\n"
  end
end

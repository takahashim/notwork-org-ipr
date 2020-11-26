#!/usr/local/bin/ruby
#   httphead.rb -- HEAD�ꥯ�����Ȥǹ�����������

require 'net/http'
require 'uri'
include URIModule

## �����ν���
if ARGV.length != 1
  print "Usage:  ruby httphead.rb <url>\n"
  exit
end

## URL�β���
url = URI.create(ARGV.shift)
host, port, path = url.host, url.port.to_i, url.path

## �ץ����ˤ��б�����
if ENV['http_proxy']
  p_uri = URI.create(ENV['http_proxy'])
  net_http = Net::HTTP::Proxy(p_uri.host, p_uri.port)
else
  net_http = Net::HTTP
end

## ��³����
net_http.start(host, port) do |http|

  ## �إå���������ƾ��ʬ��
  header = http.head2( path ) 
  case header

  when Net::SuccessCode  ## ����
    lm = header['last-modified']
    if lm
      print url,"\n\t",lm,"\n"
    else
      print url,"\n\t(unknown)\n"
    end
  when Net::RetriableCode  ## ��ư
    print "#{url}\n\t"
    print "is Moved! -> #{header['location']}\n"

  else  ## ����
    print "Error...\n"
  end
end

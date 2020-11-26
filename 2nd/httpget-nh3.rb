#!/usr/local/bin/ruby
# nh-httpget.rb -- httpget.rb with Net::HTTP
#
require 'net/http'
require 'uri'
include URIModule

default_url = 'http://localhost/'

## URL�μ���
url =  ARGV[0] || default_url
u = URI.create(url)

## �ץ����ˤ��б�����
if ENV['http_proxy']
  p_uri = URI.create(ENV['http_proxy'])
  net_http = Net::HTTP::Proxy(p_uri.host, p_uri.port)
else
  net_http = Net::HTTP
end

## ��³����
net_http.start(u.host, u.port) do |http|

  ## �إå���������ƽ���
  header = http.get2( u.path ) do |f|
    f.header.each{|key,value|
      print key.gsub(/([A-Za-z]+)/){$1.capitalize},": ",value,"\r\n"
    }
    print "\r\n"

    ## �ܥǥ������
    body = ''
    f.body do |s|
      print s
    end
  end
end

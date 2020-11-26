#!/usr/local/bin/ruby
# httpget-nh.rb -- httpget.rb with Net::HTTP

require 'net/http'
require 'uri'
include URIModule

default_url = 'http://localhost/'

## URL�μ���
url =  ARGV[0] || default_url
u = URI.create(url)

## ��³����
Net::HTTP.start(u.host, u.port) do |http|

  ## �إå���������ƾ��ʬ��
  begin
    header, data = http.get( u.path )
    header.each{|key,value|
      print key.gsub(/([A-Za-z]+)/){$1.capitalize},": ",value,"\r\n"
    }
    print "\r\n"
    print data
    
  ##�Ƽ泌�顼����
  rescue Net::ProtoRetriableError
    print "This site was moved.\n"
  rescue Net::ProtoFatalError
    print "Fatal Error.\n"
  rescue
    print "Unknown Error.\n"
  end
end
